extends CharacterBody2D

@export  var monster_rig :PackedScene
@onready var rig: Node2D = $Part/Rig
@export var gravity = 40
@export var speed=200
@export	var direction = 0
@export	var hp = 100
@export	var maxhp = 100
@export	var atk = 10
@export	var def = 10
@export var title = "Smoker"
@export var visible_range = 300 
@onready var wall_ray: RayCast2D = $Part/WallRay
@onready var player_ray: RayCast2D = $Part/PlayerRay
@onready var floor_ray: RayCast2D = $Part/FloorRay
@onready var damage_paricle: GPUParticles2D = $DamageParicle
@onready var player_ray_2: RayCast2D = $Part/PlayerRay2

var animation_player = null
func _ready() -> void:
	if monster_rig!=null:
		rig = monster_rig.instantiate()
		rig.position = $Part/Rig.position
		$Part.add_child(rig)
		$Part/Rig.queue_free()
	animation_player = rig.get_node("AnimationPlayer")	
	play("idle")
	rig.scale = Vector2(0.8,0.8)
	$ProgressBar.max_value = maxhp
	$Label.text = title
	player_ray.target_position.x = visible_range
	GameManager.fire_count +=1

func _process(delta: float) -> void:
	GameManager.add_smoke(delta*hp*0.0005)
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 3000 : queue_free()
	
	if player_ray.is_colliding():
		var p = player_ray.get_collider()
		if p!=null and p.is_in_group("Player"):		
			var d = p.position.x - position.x
			if d < -100 :
				direction = -1
			elif d > 100:	
				direction = 1
			else:
				d=0	
			play("attack")
	else:		
		play("idle","walk")	

	if is_on_floor():
		if player_ray_2.is_colliding() :
			var p = player_ray_2.get_collider()
			if p!=null and p.is_in_group("Player"):		
				direction = -direction
		
		if !floor_ray.is_colliding() || wall_ray.is_colliding():
			velocity.x = 0
			direction = -direction
		
		if 	direction>0 : $Part.scale.x = -1 
		elif direction<0 : $Part.scale.x = 1 

		var ax = direction	
		velocity.x = clamp(velocity.x+ax,-speed,speed)
		if velocity.x != 0 : play("walk","attack")
		else: play("idle")
	update_ui()
	move_and_slide()
	
func play(action,old=""):
	if animation_player.current_animation != action && animation_player.current_animation != old:
		animation_player.play(action)

func update_ui():
	$ProgressBar.value = hp

func damage(atk):
	var def = randf_range(def/2,def) 
	atk = randf_range(atk/2,atk) 
	var v = clamp(atk - def,0.1,atk)
	hp = clamp(hp-v,0,maxhp)
	damage_paricle.emitting = true
	AudioManager.attack_sfx.play()
	velocity.x -= direction*v*150
	if hp <= 0:
		AudioManager.pain.play()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
		await tween.finished
		GameManager.add_xp(5)
		GameManager.add_smoke(-5)
		GameManager.drop_item(self)
		queue_free()
		GameManager.fire_count -=1
