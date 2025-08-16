# This script is an autoload, that can be accessed from any other script!

extends Node2D

var score : int = 0
var smoke_level = 0.0
var smoke_scene = null
var player_hp = 100
var player_maxhp = 100
var player_hp_rate = 1.0
var player_wing = 0
var player_shield = 0
var player_sword = 0
var water = 0
var max_water = 100
var well = null
var fire_count = 0
var water_delay = 1.0
var masks = [0,0,0,0]
var mask_id       = 0  #หน้ากาก  0 คือไม่ใส่
var mask_power    = 0  #พลังหน้ากาก  0 คือไม่มี
var mask_lifetime = 0  #เวลาชีวิตหน้ากาก  0 คือหมด

# สำหรับการสุ่ม drop item
var wing_item = PackedScene
var mask_item = PackedScene

func _ready() -> void:
	masks = [0,1,0,0]
	wing_item = preload("res://Scenes/Prefabs/wing.tscn")
	mask_item = preload("res://Scenes/Prefabs/mask.tscn")

# Adds 1 to score variable
func add_score():
	score += 1

# Loads next level
func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func add_smoke(v):
	smoke_level = clamp(smoke_level+v,0,100.0) 
	if smoke_level>10: player_hp_rate = -smoke_level/100
	elif smoke_level>0 : player_hp_rate = 0
	else: player_hp_rate = 1
	
	#if smoke_scene != null: smoke_scene.update_level()

func add_water(v):
	water = clamp(water+v,0,max_water)
	
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
	mask_id = id
	masks[id] = clamp(masks[id]-1,0,100)
	mask_lifetime += [0,5,10,15][id]
	mask_power = [0,0.4,0.6,1.0][id]

func drop_item(node):
	var x=null
	if randf()>0.5:
		x = wing_item.instantiate()
	else:
		x = mask_item.instantiate()
	x.position = node.position - Vector2(0,40)
	node.get_parent().add_child(x)
	
