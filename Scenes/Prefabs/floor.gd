extends NinePatchRect
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	collision_shape_2d.shape.size = size
	collision_shape_2d.position = size/2
