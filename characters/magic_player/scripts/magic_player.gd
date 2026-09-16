class_name MagicPlayer
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_collision_shape: CollisionShape2D = $attackCollisionShape
@onready var hurtbox: Hurtbox = $Hurtbox

#@export var cooldown_time := 0.255
@export var magic_animated_sprite_2d: AnimatedSprite2D
@export var stats: Stats
#@export var hitbox_shape: Shape2D
@export var hitbox_shape: Shape2D

@onready var animated_sprite_2d: AnimatedSprite2D = magic_animated_sprite_2d
var face_direction = 1
var is_cooling_down = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	pass
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

func play_animation(animation_name: StringName) -> void:
	if animated_sprite_2d.animation == animation_name and animated_sprite_2d.is_playing():
		return

	animated_sprite_2d.play(animation_name)

func idle():
	play_animation("idle")

func walk_pressed():
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down" )
	return direction != Vector2.ZERO

func walk():
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down" )
	#get_axis("ui_left", "ui_right")
	#var direction_y := Input.get_axis("ui_up", "ui_down")
	var sqrt_inv = 1 / sqrt(direction.x**2 + direction.y**2) * SPEED
	if direction:
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
		velocity = Vector2(direction.x * sqrt_inv, direction.y * sqrt_inv)
	move_and_slide()

func walk_animation():
	play_animation("walk")


func douge():
	if Input.is_action_pressed("defense"):
		var direction := Vector2(0.5,0)
		#get_axis("ui_left", "ui_right")
		#var direction_y := Input.get_axis("ui_up", "ui_down")
		var sqrt_inv = 1 / sqrt(direction.x**2 + direction.y**2) * SPEED
		if direction:
			if animated_sprite_2d.flip_h:
				#animated_sprite_2d.flip_h = true
				#velocity = Vector2(direction.x * sqrt_inv, direction.y * sqrt_inv)
				velocity = Vector2(5, 0)
			else:
				#animated_sprite_2d.flip_h = false
				#velocity = Vector2(-direction.x * sqrt_inv, direction.y * sqrt_inv)
				velocity = Vector2(-5, 0)
		move_and_slide()

func douge_animation():
	if Input.is_action_pressed("defense"):
		play_animation("defense")

func hitted():
	var direction := Vector2(50,0)
	#get_axis("ui_left", "ui_right")
	#var direction_y := Input.get_axis("ui_up", "ui_down")
	var sqrt_inv = 1 / sqrt(direction.x**2 + direction.y**2) * SPEED
	var douge = randf()
	if douge <= 0.1:
		if animated_sprite_2d.flip_h:
			velocity = Vector2(direction.x * sqrt_inv, direction.y * sqrt_inv)
		else:
			velocity = Vector2(-direction.x * sqrt_inv, direction.y * sqrt_inv)
			
	move_and_slide()

func hitted_animation():
	play_animation("hitted")

func action_pressed():
	return Input.is_action_pressed("defense") or \
		Input.is_action_pressed("mealy-attack")

func static_act(time_expeld: float, min_time_state: float):
	if Input.is_action_pressed("mealy-attack"):
		if animated_sprite_2d.flip_h:
			spawn_hitbox(min_time_state, Vector2(-35, 0), min_time_state) 
		else:
			spawn_hitbox(min_time_state, Vector2(35, 0), min_time_state) 
	
func static_act_animation(time_expeld: float, min_time_state: float):
	if Input.is_action_pressed("defense"): 
		defense_animation(time_expeld, min_time_state)
		defense()		
	elif Input.is_action_pressed("mealy-attack"):
		mealy_attack_animation(time_expeld, min_time_state)

func stop_static_act_animation():
	hurtbox.stop_defend_character()
	
	
func dynamic_act(time_expeld: float, min_time_state: float):
	if Input.is_action_pressed("mealy-attack"):
		if animated_sprite_2d.flip_h:
			spawn_hitbox(min_time_state, Vector2(-35,25), min_time_state) 
		else:
			spawn_hitbox(min_time_state, Vector2(50,25), min_time_state) 

func dynamic_act_animation(time_expeld: float, min_time_state: float):
	if Input.is_action_pressed("defense"): 
		defense_animation(time_expeld, min_time_state)
	elif Input.is_action_pressed("mealy-attack"):
		mealy_attack_animation(time_expeld, min_time_state)

func defense():
	hurtbox.defend_character()

func defense_animation(time_expeld: float, min_time_state: float):
		#if time_expeld < min_time_state:
			#play_animation("defense")
		#else:
		play_animation("keep_defense")

func mealy_attack_animation(time_expeld: float, min_time_state: float):	
	if time_expeld < min_time_state:
		play_animation("mealy-attack")

#func spawn_hitbox(hitbox_lifetime: float, offset: Vector2, hitbox_scale := Vector2.ONE, min_time_state : float =1.0) -> Area2D:
func spawn_hitbox(hitbox_lifetime: float, offset: Vector2, min_time_state : float =1.0) -> Area2D:
	if is_cooling_down:
		return
	_finish_after_cooldown(min_time_state)
	var hitbox_area := hitbox.new(stats, hitbox_lifetime, hitbox_shape)
	hitbox_area.position = offset
	#hitbox_area.scale = hitbox_scale
	add_child(hitbox_area)
	return hitbox_area

func _finish_after_cooldown(_cooldown_time) -> void:
	is_cooling_down = true
	var attack_timer = get_tree().create_timer(_cooldown_time)
	attack_timer.timeout.connect(_on_timer_timeout)
#
func _on_timer_timeout() -> void:
	is_cooling_down = false
