extends Area2D

@export var amount = 0

func _ready() -> void:
	if amount<1:
		amount = randi_range(1,5)
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Label.visible = true
		$Label.text = str(amount)
		AudioManager.coin_pickup_sfx.play()
		GameManager.add_healpotion(amount)
		GameManager.mark_dead(self)
		var tween = create_tween()
		tween.tween_property($image, "scale", Vector2.ZERO, 0.3)
		tween.tween_property($Label, "position", position - Vector2(0,-40), 0.3)
		await tween.finished
		queue_free()
