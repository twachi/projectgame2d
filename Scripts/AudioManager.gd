# This script is an autoload, that can be accessed from any other script!

extends Node

@onready var jump_sfx = $JumpSfx
@onready var coin_pickup_sfx = $CoinPickup
@onready var death_sfx = $DeathSfx
@onready var respawn_sfx = $RespawnSfx
@onready var level_complete_sfx = $LevelCompleteSfx
@onready var water: AudioStreamPlayer = $Water
@onready var well: AudioStreamPlayer = $Well
@onready var music: AudioStreamPlayer = $Music

var music_on = true
var sound_on = true
var music_bus = null
var sfx_bus = null

func set_sound(v):
	sound_on = v
	AudioServer.set_bus_mute(sfx_bus,!sound_on)
	
func set_music(v):
	music_on = v
	AudioServer.set_bus_mute(music_bus,!music_on)
	
func _ready() -> void:
	music_bus = AudioServer.get_bus_index("music")
	sfx_bus = AudioServer.get_bus_index("sfx")
	music.play()
	AudioServer.set_bus_mute(music_bus,!music_on)
	AudioServer.set_bus_mute(sfx_bus,!sound_on)
		
