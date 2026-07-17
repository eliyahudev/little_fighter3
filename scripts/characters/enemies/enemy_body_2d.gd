@abstract
class_name EnemyBody2D extends CharacterBody2D

@export var stats: Stats

var can_attack
var is_attacking
var player_chase
var player
var last_position: Vector2
var health
var is_hitted
var facing_left
var is_alive

@onready var health_bar: HealthBar
@onready var enemy: AnimatedSprite2D
@onready var cooldown_timer: Timer

func _init() -> void:
	can_attack = true
	is_attacking = false
	player_chase = false
	player = null
	facing_left = false
	is_hitted = 0
	is_alive = 1
	health = stats.MAX_HEALTH
	
func _ready() -> void:
	last_position = position
	health = stats.MAX_HEALTH
	
	cooldown_timer.timeout.connect(_on_timer_timeout)

	
func _physics_process(delta: float) -> void:

	if is_alive:
		if is_hitted:
			enemy.play("hitted")
		elif player_chase:
			position +=  (player.position - position) / stats.SPEED
			enemy.play("walk")
		else:
			enemy.play("idle")
		move_and_slide()
		var relative_position = position - last_position

		if relative_position.x < 0:
			facing_left = true
		elif relative_position.x > 0:
			facing_left = false

		enemy.flip_h = facing_left
		last_position = position

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

@abstract
func animated_hit() -> void

@abstract
func _on_timer_timeout() -> void

@abstract		
func attack() -> void

@abstract		
func defense() -> void
