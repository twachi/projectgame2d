extends Node2D

func _ready() -> void:
	$CanvasModulate.visible = true

func _process(delta: float) -> void:
	if GameManager.fire_count <=0:
		$CanvasModulate.visible = false
