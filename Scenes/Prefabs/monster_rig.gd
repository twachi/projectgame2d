extends Node2D

@export var atk_power = 10


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameManager.player_damage(atk_power)

func _ready() -> void:
	$AttackArea/CollisionShape2D/Effect.emitting = true


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name=="attack" && !$Sound.playing :
		if randi_range(1,5)>1: 
			$Sound.play()
	pass # Replace with function body.
