extends Node2D

var pos = Vector2(0,0) 
var speed = Vector2(-1,0)
@onready var rig: Node2D = $CanvasLayer/Rig
var x1=150
var x2=1000

func _on_button_pressed() -> void:
	AudioManager.music.play(120)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")

func _ready() -> void:
	AudioManager.music.play(0)
	rig.get_node("AnimationPlayer").play("walk")
	pos = rig.position
	x2 = pos.x
	rig.scale = Vector2(1.5,1.5)

func _process(delta: float) -> void:
	pos += speed
	if pos.x < x1 : 
		speed.x = 1
		rig.scale.x=-1.5
	if pos.x > x2 : 
		speed.x = -1
		rig.scale.x=1.5
	rig.position = pos
	
