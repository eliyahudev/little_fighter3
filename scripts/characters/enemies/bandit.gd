extends CharacterBody2D

@export var stats: Stats
@export var hitbox_shape: Shape2D
@export var hitbox_offset := Vector2(10, 5)
@export var hitbox_scale := Vector2(0.5, 1)
@export var hitbox_lifetime := 0.3
@export var attack_roll_interval := 1.0
@export var current_state: StateMachine
@export_range(0.0, 1.0) var attack_chance := 0.5
@export_range(0.0, 1.0) var defense_chance := 0.5


const SPEED = 80.0
const JUMP_VELOCITY = -400.0

var player = null

var is_coldown := false
var is_area_exited := false
var is_attacking := false
var is_defende := false
var can_attack := true

const MAX_HEALTH = 10.0
var health = MAX_HEALTH

var facing_left := false
var is_alive = 1

var player_hit := false
var attack_roll_cooldown := 0.0

@onready var health_bar: HealthBar = $HealthBar
@onready var cooldown_timer: Timer = $Timer
@onready var enemy: AnimatedSprite2D = $animated_bandit
#@onready var detection_area: Area2D = $detection_area
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var collision_shape_2d: CollisionShape2D = $detection_area/CollisionShape2D

func _ready() -> void:
	health = MAX_HEALTH	
	cooldown_timer.timeout.connect(_on_timer_timeout)
	hurtbox.owner_hit.connect(_take_demage)
	
func player_exit_area():
	if is_area_exited:
		player = null
		player_hit = false 
		return true
	return false
	
func activate_battle_mode() -> void:
	var battle_mode = randf()
	if battle_mode > 0.95:
		attack()
	elif battle_mode > 0.9:
		defense()
	else:
		idle_player()
	
func animated_hit() -> void:
		
	enemy.flip_h = not facing_left
	if stats.health < 30 and stats.health > 0:
		enemy.play("critic hitted")
	else:
		enemy.play("hitted")
	cooldown_timer.start()
	
	if stats.health == 0:
		enemy.play("die")

func is_player_in_range():
	if is_coldown:
		return false
	var pos_x = (player.position - position).x
	var pos_y = (player.position - position).y
	
	if abs(pos_x) < 25.0:
		return true
	if abs(pos_y) > 25.0:
		return true
	return false
	
func attack() -> void:
	if not can_attack:
		return

	#enemy.play("punch")

	var attack_rate = randf()
	if attack_rate < attack_chance:
		can_attack = false
		is_attacking = true
		enemy.play("punch")
		spawn_attack_hitbox()
		is_coldown = true
		cooldown_timer.start()

func defense():
	var defense_rate = randf()
	if defense_rate < defense_chance:
		is_defende = true
		print("defense")
		enemy.play("defense")
		is_coldown = true
		cooldown_timer.start()
	
func idle_player() -> void:
	enemy.play("idle")

func chase_player() -> void:
	#detection_area
	face_target(player)

	var pos_x = (player.position - position).x
	var pos_y = (player.position - position).y
	
	if not is_coldown:
		if abs(pos_x) > 18.0:
			position.x += pos_x / SPEED
			enemy.play("walk")
		if abs(pos_y) > 18.0:
			position.y += pos_y / SPEED
			enemy.play("walk")
		#position +=  (player.position - position) / SPEED
		if not abs(pos_y) > 18.0 and not abs(pos_x) > 18.0:
			enemy.play("idle")
		
func spawn_attack_hitbox() -> void:
	var facing_sign := -1 if facing_left else 1
	var facing_offset := Vector2(hitbox_offset.x * facing_sign, hitbox_offset.y)
	var hitbox_area := hitbox.new(stats, hitbox_lifetime, hitbox_shape)
	hitbox_area.position = facing_offset
	hitbox_area.scale = hitbox_scale
	add_child(hitbox_area)

func _on_timer_timeout() -> void:
	is_coldown = false
	is_attacking = false
	can_attack = true
	is_defende = false

func play_walk_animation():
	enemy.play("walk")


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	collision_shape_2d.shape.radius *= 2

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body != player:
		return
	collision_shape_2d.shape.radius = collision_shape_2d.shape.radius / 2
	is_area_exited = true
	
func face_target(target: Node2D) -> void:
	facing_left = target.global_position.x < global_position.x
	enemy.flip_h = facing_left

func _take_demage():
	animated_hit()
