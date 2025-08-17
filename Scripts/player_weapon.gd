extends Node2D

var atk_power = 30

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !visible : return
	if body.is_in_group("monster"):
		body.damage(atk_power)
