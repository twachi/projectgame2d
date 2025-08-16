extends Area2D

@export var mask = 0

func _ready() -> void:
	if mask==0:
		mask = randi_range(1,3)
	setMask(mask)	

func setMask(m):
	mask = m	
	$mask01.visible = mask==1
	$mask02.visible = mask==2
	$mask03.visible = mask==3

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameManager.add_mask(mask)
		queue_free()
