extends Node2D


func _on_button_pressed() -> void:
	AudioManager.music.play()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")

func _ready() -> void:
	$Rig.get_node("AnimationPlayer").play("walk")
	$AnimationPlayer.play("start")
