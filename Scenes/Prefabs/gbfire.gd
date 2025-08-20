extends Node2D

@export var hp = 100

func _ready() -> void:
	$ProgressBar.max_value = hp
	

func _process(delta: float) -> void:
	$ProgressBar.value = hp
	$Light.energy = randf_range(0.6,1)
	if hp>0:
		GameManager.add_smoke(delta*hp*0.0005)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("water"):
		$Explosion.play()
		body.queue_free()
		hp -= randi_range(25,75)
		if hp<=50: 
			$Fire.amount = 5
			$Fire.lifetime = 1
			$Fire.scale = Vector2(0.2,0.2)
		if hp<=0 :
			GameManager.add_xp(5)
			GameManager.add_smoke(-5)
			queue_free()
			GameManager.drop_item(self)

func _on_tree_exited() -> void:
	GameManager.fire_count -=1
	

func _on_tree_entered() -> void:
	GameManager.fire_count +=1
