extends Node2D

@export var atk_power = 10

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameManager.player_damage(atk_power)
