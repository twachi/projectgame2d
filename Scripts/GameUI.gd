extends Control

@onready var score_texture = %Score/ScoreTexture
@onready var score_label = %Score/ScoreLabel
@onready var smoke_label: Label = %SmokeLabel
@onready var hp_label: Label = %HpLabel
@onready var water_label: Label = %WaterLabel
@onready var fire_label: Label = %FireLabel
@onready var m1label: Label = $"../Inventory/Button1/Label"
@onready var m2label: Label = $"../Inventory/Button2/Label"
@onready var m3label: Label = $"../Inventory/Button3/Label"
@onready var m4label: Label = $"../Inventory/Button4/Label"
@onready var m5label: Label = $"../Inventory/Button5/Label"
@onready var music_off: Sprite2D = $"../Control/MusicButton/music_off"
@onready var sound_on: Sprite2D = $"../Control/SoundButton/sound_on"
@onready var sound_off: Sprite2D = $"../Control/SoundButton/sound_off"

func _ready() -> void:
	update_audio()
	
func update_audio():
	music_off.visible = !AudioManager.music_on
	sound_off.visible = !AudioManager.sound_on
	sound_on.visible = AudioManager.sound_on

func _process(_delta):
	# Set the score label text to the score variable in game maanger script
	score_label.text = "x %d" % GameManager.score
	smoke_label.text = "x %d" % GameManager.smoke_level
	hp_label.text  = "x %.2f" % GameManager.player_hp
	water_label.text = "x %d" % GameManager.water
	fire_label.text = "x %d" % GameManager.fire_count
	m1label.text = str(GameManager.masks[1])
	m2label.text = str(GameManager.masks[2])
	m3label.text = str(GameManager.masks[3])
	m4label.text = str(GameManager.player_wing)
	m5label.text = str(GameManager.water)

func _on_button_1_pressed() -> void:
	GameManager.set_mask(1)


func _on_button_2_pressed() -> void:
	GameManager.set_mask(2)

func _on_button_3_pressed() -> void:
	GameManager.set_mask(3)

func _on_button_4_pressed() -> void:
	Input.action_press("wing")
	Input.action_release("wing")


func _on_button_5_pressed() -> void:
	Input.action_press("water")
	Input.action_release("water")


func _on_music_button_pressed() -> void:
	AudioManager.set_music(!AudioManager.music_on)
	update_audio()


func _on_sound_button_pressed() -> void:
	AudioManager.set_sound(!AudioManager.sound_on)
	update_audio()
