extends Area2D

@onready var help: Label = $help
@export var text = "ข้อความ"

func _ready() -> void:
	help.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		help.text = text
		help.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		help.visible = false
