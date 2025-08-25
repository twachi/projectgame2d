extends Node2D

@export var hp = 100
@export var xp = 15
var smoke_time=0
var onscreen = false

func _ready() -> void:
	$ProgressBar.max_value = hp
	$Fire.emitting = true
	$Light.visible = true
	smoke_time -= randi_range(1,20)	

func _process(delta: float) -> void:
	if !onscreen : return
	$ProgressBar.value = hp
	$Light.energy = randf_range(1,1.5)
	smoke_time += delta
	if hp>0 and smoke_time>1:
		smoke_time=0
		GameManager.add_smoke(randf_range(0.1,hp*0.005))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("water"):
		$Animate.play("start")
		AudioManager.water.play()
		body.queue_free()
		hp -= randi_range(25,75)
		if hp<=50: 
			$Fire.amount = 5
			$Fire.lifetime = 1
			$Fire.scale = Vector2(0.2,0.2)
		if hp<=0 :
			GameManager.add_xp(xp)
			GameManager.add_smoke(-5)
			GameManager.mark_dead(self)
			queue_free()
			GameManager.drop_item(self)

func _on_tree_exited() -> void:
	GameManager.fire_count -=1
	

func _on_tree_entered() -> void:
	GameManager.fire_count +=1


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Fire.emitting = true
	$Light.visible = true
	onscreen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	onscreen = false
	$Fire.emitting = false
	$Light.visible = false
