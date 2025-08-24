extends Node2D

func _ready() -> void:
	$CanvasModulate.visible = true
	$UserInterface.visible = true
	AudioManager.music.stop()
	AudioManager.horror_music.play()
	GameManager.save_game()
	

func _process(delta: float) -> void:
	if GameManager.fire_count <=0:
		$CanvasModulate.visible = false
