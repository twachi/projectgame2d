extends RigidBody2D

var canpick = true
var speed = null

func _ready() -> void:
	if speed == null: speed = Vector2(-50,-450)
	linear_velocity = speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if canpick and body.is_in_group("Player"):
		AudioManager.coin_pickup_sfx.play()
		linear_velocity =  Vector2(0,-50)
		await get_tree().create_timer(0.5).timeout
		GameManager.add_water(1)
		queue_free()

func setLifeTime(t):
	await get_tree().create_timer(t).timeout
	queue_free()
