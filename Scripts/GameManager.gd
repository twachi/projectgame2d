# This script is an autoload, that can be accessed from any other script!

extends Node2D

var score : int = 0
var smoke_level = 0.0
var smoke_scene = null
var player_hp = 100
var player_maxhp = 100
var player_hp_rate = 1.0
var player_wing = 1
var player_shield = 0
var player_sword = 0
var player_level = 1
var player_xp = 0
var player_levelxp = 100

var water = 0
var max_water = 200
var well = null
var fire_count = 0
var water_delay = 1.0
var masks = [0,1,1,1]
var potion_heal   = 1  # น้ำยาเพิ่มเลือด
var mask_id       = 0  #หน้ากาก  0 คือไม่ใส่
var mask_power    = 0  #พลังหน้ากาก  0 คือไม่มี
var mask_lifetime = 0  #เวลาชีวิตหน้ากาก  0 คือหมด
var player_def = 1
var player_atk = 10
# สำหรับการสุ่ม drop item
var drop_items : Array[PackedScene] =[]
var player_scene = null

var current_level: String = ""  # ค่าเริ่มต้น (ด่านแรก)
var save_path := "user://game.save"
var save_player_position = Vector2.ZERO
var death_log: Dictionary = {}

func restart_game():
	player_level = 1
	player_xp = 0
	player_levelxp = 100
	player_atk  = 10
	player_def	= 1
	player_hp = 100
	player_maxhp = 100
	player_sword = 0
	player_wing = 0
	potion_heal = 0
	score = 0
	masks = [0,1,1,1]
	water = 0
	death_log = {}
	smoke_level = 0
	
func save_game():
	current_level = get_tree().current_scene.scene_file_path
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var pos = Vector2(player_scene.position)
		var payload: Dictionary = {
			"current_level" : current_level,
			"player" : [pos.x, pos.y],
			"deadlog": death_log,   
			"music" : AudioManager.music_on,
			"sound" : AudioManager.sound_on,
			"player_level": player_level,
			"player_xp": player_xp,
			"player_levelxp": player_levelxp,
			"player_atk": player_atk,
			"player_def": player_def,
			"player_hp": player_hp,
			"player_maxhp": player_maxhp,
			"player_sword": player_sword,
			"player_wing": player_wing,
			"potion_heal": potion_heal,
			"smoke_level": smoke_level,
			"score": score,
			"masks": masks,
			"water" : water
		}
		var json_text = JSON.stringify(payload, "  ")
		file.store_pascal_string(json_text)
		file.close()
		print("Saved level:", current_level)

func has_save():
	return FileAccess.file_exists(save_path)


func load_game():
	restart_game()
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var text = file.get_pascal_string()
		var data = JSON.parse_string(text)        		
		file.close()
		current_level = data.get("current_level", current_level)
		player_level = data.get("player_level", player_level)
		player_xp = data.get("player_xp", player_xp)
		player_levelxp = data.get("player_levelxp", player_levelxp)
		player_atk = data.get("player_atk", player_atk)
		player_def = data.get("player_def", player_def)
		player_hp = data.get("player_hp", player_hp)
		player_maxhp = data.get("player_maxhp", player_maxhp)
		player_sword = data.get("player_sword", player_sword)
		player_wing = data.get("player_wing", player_wing)
		potion_heal = data.get("potion_heal", potion_heal)
		smoke_level = data.get("smoke_level", smoke_level)
		score = data.get("score", score)
		water = data.get("water",0)
		death_log = data.get("deadlog",{})
		var pos = data.get("player",Vector2.ZERO)
		save_player_position = Vector2(pos[0],pos[1])
		AudioManager.music_on = data.get("music",true)
		AudioManager.sound_on = data.get("sound",true)
		AudioManager.set_music(AudioManager.music_on)
		AudioManager.set_sound(AudioManager.sound_on)
		get_tree().change_scene_to_file(GameManager.current_level)

func _ready() -> void:
	drop_items.push_back( preload("res://Scenes/Prefabs/wing.tscn"))
	drop_items.push_back( preload("res://Scenes/Prefabs/mask.tscn"))
	drop_items.push_back( preload("res://Scenes/Prefabs/sword.tscn"))
	drop_items.push_back( preload("res://Scenes/Items/potion_heal.tscn"))
	
# Adds 1 to score variable
func add_score():
	score += 1

# Loads next level
func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func add_smoke(v):
	smoke_level = clamp(smoke_level+v,0,100.0) 
	if smoke_level>10: player_hp_rate = -smoke_level/200
	elif smoke_level>0 : player_hp_rate = 0
	else: player_hp_rate = 1
	
	#if smoke_scene != null: smoke_scene.update_level()

func add_water(v):
	water = clamp(water+v,0,max_water)

func add_hp(v):
	player_hp = clamp(player_hp+v,0,player_maxhp)

func update_hp(delta):
	var rate = player_hp_rate
	if mask_power>0: rate += mask_power
	player_hp = clamp(player_hp+rate*delta,0,player_maxhp)
	if mask_lifetime <= 0:
		set_mask(0)
	else:
		mask_lifetime -= delta	
		
func add_mask(id,v=1):
	id = clamp(id,1,3)
	masks[id] = clamp(masks[id]+v,0,100)	

func set_mask(id):
	id = clamp(id,0,3)
	if id>0 and masks[id] <= 0 : return
	var time = [0,60,40,30][id]
	if mask_id == id: mask_lifetime+=time
	else: mask_lifetime=time
	mask_id = id
	masks[id] = clamp(masks[id]-1,0,100)
	mask_power = [0,0.4,0.6,1.0][id]

func drop_item(node,id=-1):
	var i = randi_range(0,drop_items.size()-1)
	if id>=0 : i= clamp(id,0,drop_items.size()-1)	
	var x = drop_items[i].instantiate()
	x.position = node.position
	x.scale = Vector2.ZERO
	node.get_parent().add_child(x)
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(x, "scale", Vector2.ONE, 0.2)
	tween.tween_property(x, "position", node.position - Vector2(0,150), 0.2)
	tween.tween_property(x, "position", node.position - Vector2(0,40), 0.5)
	tween2.tween_property(x, "rotation_degrees", 360, 1.5)
	await tween.finished
	await tween2.finished
	
func add_wing(n):
	player_wing += n

func add_sword(n):
	player_sword += n

func player_damage(atk=1, from=Vector2.ZERO):
	var def = randf_range(player_def/2,player_def) 
	atk = randf_range(atk/2,atk) 
	var v = clamp(atk - def,0.1,atk)
	player_hp = clamp(player_hp-v,0,player_maxhp)
	AudioManager.death_sfx.play()
	if player_scene != null:
		player_scene.damage(from)
		
func add_xp(n):
	player_xp += n
	if player_xp >= player_levelxp:
		levelUp()

func levelUp():
	if player_xp < player_levelxp: return
	player_level +=1
	player_xp = clamp(player_xp-player_levelxp,0,player_levelxp)
	player_levelxp = 100+(player_level*50)
	player_maxhp = 100 + (player_level*10)
	player_def = 1 + player_level
	player_atk = clamp(player_atk+player_level,1,100)
	player_hp_rate = clamp(player_level,1,10)

func use_healpotion():
	if potion_heal>0:
		AudioManager.level_complete_sfx.play()
		add_hp(50)
		add_healpotion(-1)
		
func add_healpotion(amount):
	potion_heal = clamp(potion_heal+amount,0,100)

func mark_dead(node:Node2D):
	var id = str(node.get_path())
	death_log[id] = true
	
func restore_deadlog():
	if player_scene!=null and save_player_position.x != 0:
		player_scene.position = save_player_position

	var scene = get_tree().current_scene
	for node in scene.get_tree().get_nodes_in_group("saveable"):
		var monster_id = str(node.get_path())
		if death_log.get(monster_id,false):
			node.queue_free()
