extends Node2D

@onready var fg_objects: Parallax2D = $FgObjects


func _ready() -> void:
	$CanvasModulate.visible = true
	$UserInterface.visible = true
	if fg_objects != null:
		fg_objects.modulate.a = 0.8
	AudioManager.music.stop()
	AudioManager.horror_music.play()
	GameManager.player_scene = $Player
	GameManager.restore_deadlog()
	

func _process(delta: float) -> void:
	if GameManager.fire_count <=0:
		$CanvasModulate.visible = false
