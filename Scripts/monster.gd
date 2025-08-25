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
@export var xp = 30
@export var title = "Smoker"
@export var visible_range = 300 
@export var pitch = 1.0
@onready var wall_ray: RayCast2D = $Part/WallRay
@onready var player_ray: RayCast2D = $Part/PlayerRay
@onready var floor_ray: RayCast2D = $Part/FloorRay
@onready var damage_paricle: GPUParticles2D = $DamageParicle
@onready var player_ray_2: RayCast2D = $Part/PlayerRay2
var smoke_time=0
var animation_player = null
var onscreen = false
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
	player_ray_2.target_position.x = visible_range
	GameManager.fire_count +=1
	smoke_time = -randi_range(1,30)
	$PointLight2D.visible = true

func _process(delta: float) -> void:
	smoke_time += delta
	if !onscreen: return
	if randi_range(0,5)>2:
		$PointLight2D.energy = randf_range(0.8,1.2)
	if smoke_time >1:
		smoke_time = 0
		GameManager.add_smoke(randf_range(0.1,hp*0.01))
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
				if direction==0: direction=1		
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
		AudioManager.pain.pitch_scale = pitch
		AudioManager.pain.play()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
		await tween.finished
		GameManager.add_xp(xp)
		GameManager.add_smoke(-5)
		GameManager.drop_item(self)
		GameManager.mark_dead(self)
		queue_free()
		GameManager.fire_count -=1
		#AudioManager.pain.pitch_scale = 1.0


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if rig!=null:
		onscreen = true
		$PointLight2D.visible = true
		rig.effect.emitting = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if rig!=null:
		onscreen = false
		rig.effect.emitting = false
		$PointLight2D.visible = false
	
