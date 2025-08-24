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
