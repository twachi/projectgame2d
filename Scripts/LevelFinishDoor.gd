extends Area2D

# Define the next scene to load in the inspector
@export var next_scene : PackedScene
@export_file var next_scenefile = ""
@export_multiline var text = "ต้องตักน้ำไปดับไฟ และ กำจัดผีร้ายทั้งหมด\nจึงจะสามารถผ่านประตูได้"

func _ready() -> void:
	if next_scene == null && next_scenefile != "":
		next_scene = load(next_scenefile).instantiate() as PackedScene
# Load next level scene when player collide with level finish door.
func _on_body_entered(body):
	if GameManager.fire_count <=0 and GameManager.smoke_level == 0 and body.is_in_group("Player"):
		get_tree().call_group("Player", "death_tween") # death_tween is called here just to give the feeling of player entering the door.
		AudioManager.level_complete_sfx.play()
		GameManager.player_hp = GameManager.player_maxhp
		SceneTransition.load_scene(next_scene)

func _process(delta: float) -> void:
	if GameManager.smoke_level>0:
		if GameManager.fire_count >0 :
			$Label.text =  text
		else:
			$Label.text = "รอให้มลพิษหมดก่อน\nจึงจะไปด่านต่อไป"
		$Part.modulate.a = 0.4
	else:
		$Label.text = "เข้าประตูเพื่อไปด่านต่อไป"
		$Part.modulate.a = 1
