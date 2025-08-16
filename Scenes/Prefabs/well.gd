extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var started = false
var active = false
@export var Bucket: PackedScene

func start(player):
	if started : return
	started = true
	animation_player.play("start")
	player.play("well")
	$Effect.emitting = true
	await get_tree().create_timer(GameManager.water_delay).timeout
	AudioManager.well.play()
	animation_player.stop()
	started = false
	var b = Bucket.instantiate()
	b.position = Vector2(0,-30)
	add_child(b)
	player.play("idle")
	

func _ready() -> void:
	$help.visible = false
	$image.modulate = Color(0.5,0.5,0.5)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		active  = true
		$help.visible = true
		$image.modulate = Color(1,1,1)
		GameManager.well = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if GameManager.well == self:
			active  = false
			$image.modulate = Color(0.5,0.5,0.5)
			GameManager.well = null
			$help.visible = false
