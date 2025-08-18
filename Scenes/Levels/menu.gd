extends Node2D

var pos = Vector2(0,0) 
var speed = Vector2(-3,0)
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

func _process(delta: float) -> void:
	pos += speed
	if pos.x < x1 : 
		speed.x = 3
		rig.scale.x=-1.5
	if pos.x > x2 : 
		speed.x = -3
		rig.scale.x=1.5
	rig.position = pos
	
