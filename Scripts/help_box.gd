extends Area2D

@onready var help: Label = $help
@export_multiline var text = ""

var shown = true

func _ready() -> void:
	shown = false
	for x in get_children():
		x.visible = false

func _on_body_entered(body: Node2D) -> void:
	if !shown and body.is_in_group("Player"):
		help.text = text
		#shown = true
		for x in get_children():
			x.visible = true
		

func _on_body_exited(body: Node2D) -> void:
	help.visible = false
	for x in get_children():
		x.visible = false
