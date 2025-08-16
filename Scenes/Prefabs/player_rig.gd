extends Node2D

@export var wing = false
@export var flip = false
@export var sword = 0
@onready var wing_2: Polygon2D = $Part/Body/Wing2
@onready var wing_1: Polygon2D = $Part/Body/Wing1
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sword_part1: Polygon2D = $Part/Body/Arm_Right/Sword
var current_animate = "idle"
@onready var mask_01: Polygon2D = $Part/Head/mask01
@onready var mask_02: Polygon2D = $Part/Head/mask02
@onready var mask_03: Polygon2D = $Part/Head/mask03

func _ready() -> void:
	$AnimationPlayer.speed_scale=2
	setWing(wing)
	setSword(sword)

func _process(delta: float) -> void:
	mask_01.visible = GameManager.mask_id == 1
	mask_02.visible = GameManager.mask_id == 2
	mask_03.visible = GameManager.mask_id == 3

func setSword(v):
	if v!=sword:
		sword=v
		sword_part1.visible = false		
		if v==1:
			sword_part1.visible = true		

func setWing(v,time=0):
	wing = v
	wing_1.visible = v
	wing_2.visible = v
	if v and time>0:
		await get_tree().create_timer(time).timeout
		setWing(false)

func setFlip(f):
	if flip != f:
		flip = f
		if f:
			$Part.scale.x = -1
		else:
			$Part.scale.x = 1	
		
func play(action):
	if $AnimationPlayer.current_animation != action :
		if action=="idle": $AnimationPlayer.speed_scale=0.5
		else: $AnimationPlayer.speed_scale=2
		$AnimationPlayer.play(action)
		
	current_animate = $AnimationPlayer.current_animation
	
