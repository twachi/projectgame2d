extends Area2D

# Define the next scene to load in the inspector
@export var next_scene : PackedScene

# Load next level scene when player collide with level finish door.
func _on_body_entered(body):
	if GameManager.smoke_level == 0 and body.is_in_group("Player"):
		get_tree().call_group("Player", "death_tween") # death_tween is called here just to give the feeling of player entering the door.
		AudioManager.level_complete_sfx.play()
		GameManager.player_hp = GameManager.player_maxhp
		SceneTransition.load_scene(next_scene)

func _process(delta: float) -> void:
	if GameManager.smoke_level>0:
		if GameManager.fire_count >0 :
			$Label.text = "ต้องตักน้ำไปดับไฟทั้งหมด\nเพื่อลดมลพิษ"
		else:
			$Label.text = "รอให้มลพิษหมดก่อน\nจึงจะไปด่านต่อไป"
		$Part.visible = false
	else:
		$Label.text = "ตอนนี้อากาศบริสุทธิ์แล้ว"
		$Part.visible = true	
