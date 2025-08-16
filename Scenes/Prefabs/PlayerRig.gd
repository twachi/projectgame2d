# res://player/PlayerRig.gd
extends Node2D
class_name PlayerRig

@export var facing = 1

func set_facing(v):
	facing = v
	scale.x = 1 if facing >= 0 else -1

func _ready():
	set_facing(facing)
