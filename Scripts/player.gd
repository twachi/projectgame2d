extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 200
@export var jump_force : float = 1300
@export var gravity : float = 40
@export var max_jump_count : int = 2

var jump_count : int = 2

@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = false

var is_grounded : bool = false

@onready var player_sprite = $AnimatedSprite2D
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles
@onready var player_rig: Node2D = $PlayerRig

@export var Bucket: PackedScene = null

# --------- BUILT-IN FUNCTIONS ---------- #


func _process(_delta):
	# Calling functions
	movement()
	player_animations()
	flip_player()
	GameManager.update_hp(_delta)
	if GameManager.player_hp <= 0:
		death_tween()
	
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement():
	var power=1;
	if player_rig.wing : power = 2
	# Gravity
	if !is_on_floor():
		velocity.y += (gravity/power)
		if velocity.y > 2000:
			velocity.y = 0
			death_tween()
			
	elif is_on_floor():
		jump_count = max_jump_count
	
	handle_jumping()
	
	if !player_rig.wing and GameManager.player_wing>0 and Input.is_action_just_pressed("wing"):
		player_rig.setWing(true,20)
		GameManager.player_wing -= 1
	
	# ตักน้ำ
	if Input.is_action_just_pressed("water"):
		if GameManager.well != null:
			player_rig.setFlip(false)
			GameManager.well.start(player_rig)
		elif GameManager.water>0:
			var b = Bucket.instantiate()
			var direction = 1
			if player_rig.flip : direction = -1
			b.canpick = false
			b.position = position + Vector2(0,-30)
			b.speed = Vector2(direction*400,-200)
			AudioManager.water.play()
			GameManager.add_water(-1)
			get_parent().add_child(b)	
			b.setLifeTime(2)
			
		
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	
	velocity = Vector2(inputAxis * move_speed*power, velocity.y)
	move_and_slide()

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1

# Player jump
func jump():
	jump_tween()
	AudioManager.jump_sfx.play()
	velocity.y = -jump_force

# Handle Player Animations
func player_animations():
	particle_trails.emitting = false
	
	if is_on_floor():
		if abs(velocity.x) > 0:
			if player_rig.wing : particle_trails.emitting = true
			player_rig.play("walk")
		else:
			if player_rig.current_animate in ["walk","jump"]:
				player_rig.play("idle")
	else:
		player_rig.play("jump")

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0:
		player_rig.setFlip(true)
	if velocity.x > 0:
		player_rig.setFlip(false)
		

# Tween Animations
func death_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	global_position = spawn_point.global_position
	await get_tree().create_timer(0.3).timeout
	AudioManager.respawn_sfx.play()
	respawn_tween()

func respawn_tween():
	var tween = create_tween()
	GameManager.player_hp = clamp(GameManager.player_hp,GameManager.player_maxhp * 0.2,GameManager.player_maxhp)
		
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15) 

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if  _body.is_in_group("wing"):
		GameManager.player_wing += 1 
		AudioManager.coin_pickup_sfx.play()
		_body.queue_free()
		
	if _body.is_in_group("Traps"):
		AudioManager.death_sfx.play()
		death_particles.emitting = true
		death_tween()
