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
@onready var m6label: Label = $"../Inventory/Button6/Label"
@onready var label_lv: Label = $Score/LabelLv
@onready var label_xp: Label = $Score/LabelXp
@onready var label_potionhp: Label = $"../Inventory/Button7/Label"

var full = false
var showkey = false

func _ready() -> void:
	update_audio()
	alert_label.visible = false 
	$"../Control/Keyboards".visible = showkey
	$"../PanelInfo".visible = false
	
func update_audio():
	music_off.visible = !AudioManager.music_on
	sound_off.visible = !AudioManager.sound_on
	sound_on.visible = AudioManager.sound_on

func _process(_delta):
	# Set the score label text to the score variable in game maanger script
	score_label.text = "x %d" % GameManager.score
	smoke_label.text = "%.2f %%" % GameManager.smoke_level
	hp_label.text  = "%.2f %%" % GameManager.player_hp
	water_label.text = "x %d" % GameManager.water
	fire_label.text = "x %d" % GameManager.fire_count
	m1label.text = "%d"%(GameManager.masks[1])
	m2label.text = "%d"%(GameManager.masks[2])
	m3label.text = "%d"%(GameManager.masks[3])
	m4label.text = "%d"%(GameManager.player_wing)
	m5label.text = "%d"%(GameManager.water)
	m6label.text = "%d"%(GameManager.player_sword)
	label_lv.text = "%d"%(GameManager.player_level)
	label_xp.text = "%d"%(GameManager.player_xp)
	label_potionhp.text = "%d"%(GameManager.potion_heal)
	if $"../PanelInfo".visible:
		print_info()
	if Input.is_action_just_pressed("info"):
		toggle_info()	
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Scenes/Levels/Menu.tscn")	
	if Input.is_action_just_pressed("save"):
		GameManager.save_game()
		alert("Game is saved")

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


func _on_button_6_pressed() -> void:
	Input.action_press("sword")
	Input.action_release("sword")


func _on_left_button_5_pressed() -> void:
	Input.action_press("Jump")
	Input.action_release("Jump")

func _on_a_button_button_down() -> void:
	Input.action_press("Left")

func _on_a_button_button_up() -> void:
	Input.action_release("Left")


func _on_d_button_button_down() -> void:
	Input.action_press("Right")


func _on_d_button_button_up() -> void:
	Input.action_release("Right")


func _on_c_button_pressed() -> void:
	Input.action_press("attack")
	Input.action_release("attack")
	pass # Replace with function body.

func _on_z_button_button_down() -> void:
	Input.action_press("wing")


func _on_z_button_button_up() -> void:
	Input.action_release("wing")

func _on_x_button_button_down() -> void:
	Input.action_press("water")


func _on_x_button_button_up() -> void:
	Input.action_release("water")


func _on_fullscreen_button_pressed() -> void:
	full = !full
	if full:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:		
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func _on_keyboard_button_pressed() -> void:
	showkey = !showkey
	$"../Control/Keyboards".visible = showkey


func _on_button_7_pressed() -> void:
	GameManager.use_healpotion()

func _on_info_close_btn_pressed() -> void:
	$"../PanelInfo".visible = false

func toggle_info():
	$"../PanelInfo".visible = !($"../PanelInfo".visible)

@onready var atk_label: Label = $"../PanelInfo/AtkLabel"
@onready var def_label: Label = $"../PanelInfo/DefLabel"
@onready var exp_label: Label = $"../PanelInfo/ExpLabel"
@onready var lv_label: Label = $"../PanelInfo/LvLabel"
@onready var ihp_label: Label = $"../PanelInfo/HPLabel"
@onready var rate_label: Label = $"../PanelInfo/RateLabel"
@onready var alert_label: Label = $"../AlertLabel"

func print_info():
	atk_label.text = "ATK: %d" % GameManager.player_atk
	def_label.text = "DEF: %d" % GameManager.player_def
	exp_label.text = "EXP: %d/%d" % [GameManager.player_xp,GameManager.player_levelxp]
	lv_label.text = "Level: %d" % GameManager.player_level
	ihp_label.text = "HP:%d/%d" %[GameManager.player_hp,GameManager.player_maxhp]
	rate_label.text = "Heal Rate:%.2f" % GameManager.player_hp_rate
	

func _on_i_button_pressed() -> void:
	toggle_info()


func _on_esc_button_pressed() -> void:
	Input.action_press("exit")
	Input.action_release("exit")

func alert(text):
	alert_label.text = text
	alert_label.visible = true
	alert_label.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(alert_label, "scale", Vector2(1,1), 0.3)
	await get_tree().create_timer(2).timeout
	alert_label.visible = false 

func _on_save_button_pressed() -> void:
	GameManager.save_game()
	alert("Game is saved")
