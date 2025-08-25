extends Node2D

var pos = Vector2(0,0) 
var speed = Vector2(-1,0)
@onready var rig: Node2D = $CanvasLayer/Control/Rig
var x1=150
var x2=1000
@onready var button_continue: Button = $CanvasLayer/Control/ButtonContinue

func _on_button_pressed() -> void:
	AudioManager.music.stop()
	AudioManager.horror_music.play()
	GameManager.restart_game()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")

func _ready() -> void:
	AudioManager.music.play(0)
	AudioManager.horror_music.stop()
	rig.get_node("AnimationPlayer").play("walk")
	pos = rig.position
	x2 = pos.x
	rig.scale = Vector2(1,1)
	button_continue.visible = GameManager.has_save()

func _process(delta: float) -> void:
	pos += speed
	if pos.x < x1 : 
		speed.x = 1
		rig.scale.x=-1
	if pos.x > x2 : 
		speed.x = -1
		rig.scale.x=1
	rig.position = pos

func _on_button_continue_pressed() -> void:
	GameManager.load_game()
