extends RigidBody2D

var canpick = true
var speed = null
var water_count = 2

func _ready() -> void:
	if speed == null: speed = Vector2(-50,-450)
	linear_velocity = speed
	water_count = randi_range(1,10)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if canpick and body.is_in_group("Player"):
		linear_velocity =  Vector2(0,-50)
		AudioManager.coin_pickup_sfx.play()
		await get_tree().create_timer(0.5).timeout
		GameManager.add_water(water_count)
		GameManager.add_xp(1)
		queue_free()

func setLifeTime(t):
	await get_tree().create_timer(t).timeout
	queue_free()
