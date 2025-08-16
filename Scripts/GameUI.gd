extends Control

@onready var score_texture = %Score/ScoreTexture
@onready var score_label = %Score/ScoreLabel
@onready var smoke_label: Label = %SmokeLabel
@onready var hp_label: Label = %HpLabel
@onready var water_label: Label = %WaterLabel
@onready var wing_label: Label = %WingLabel
@onready var fire_label: Label = %FireLabel
@onready var m1label: Label = $"../Inventory/Button1/Label"
@onready var m2label: Label = $"../Inventory/Button2/Label"
@onready var m3label: Label = $"../Inventory/Button3/Label"


func _process(_delta):
	# Set the score label text to the score variable in game maanger script
	score_label.text = "x %d" % GameManager.score
	smoke_label.text = "x %d" % GameManager.smoke_level
	hp_label.text  = "x %.2f" % GameManager.player_hp
	water_label.text = "x %d" % GameManager.water
	wing_label.text = "x %d" % GameManager.player_wing
	fire_label.text = "x %d" % GameManager.fire_count
	m1label.text = str(GameManager.masks[1])
	m2label.text = str(GameManager.masks[2])
	m3label.text = str(GameManager.masks[3])

func _on_button_1_pressed() -> void:
	GameManager.set_mask(1)


func _on_button_2_pressed() -> void:
	GameManager.set_mask(2)

func _on_button_3_pressed() -> void:
	GameManager.set_mask(3)
