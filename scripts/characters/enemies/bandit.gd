extends CharacterBody2D

@export var stats: Stats

const SPEED = 40.0
const JUMP_VELOCITY = -400.0

var can_attack := true
var is_attacking := false

var player_chase = false
var player = null

var last_position: Vector2

const MAX_HEALTH = 10.0
var health = MAX_HEALTH

var is_hitted = 0;
var facing_left := false
var is_alive = 1

@onready var health_label: Label = $ProgressBar/healthLabel
@onready var health_bar: HealthBar = $HealthBar
	
@onready var enemy: AnimatedSprite2D = $animated_bandit
@onready var cooldown_timer: Timer = $Timer

func _ready() -> void:
	last_position = position
	#set_health_label()
	health = MAX_HEALTH
	#set_health_bar()
	
	cooldown_timer.timeout.connect(_on_timer_timeout)

#func set_health_label() -> void:
	#health_label.text = "health %s" % health

#func set_health_bar() -> void:
	#progress_bar.value = health

#func demage()->void:
	#health -= 1
	#set_health_label()
	#set_health_bar()
	
func _physics_process(delta: float) -> void:
	#var direction :=  Input.get_axis("ui_left", "ui_right")
	#var y_direction := Input.get_axis("ui_up", "ui_down")

	#velocity = Vector2.ZERO
	#direction * SPEED
	#velocity.y = 
	#y_direction * SPEED

	#if direction < 0:
		#enemy.flip_h = true
	#elif direction > 0:
		#enemy.flip_h = false

	#if Input.is_action_just_pressed("mealy-attack") :
		#attack()
	if is_alive:
		if is_hitted:
			enemy.play("hitted")
		elif player_chase:
			position +=  (player.position - position) / SPEED
			enemy.play("walk")
		else:
			enemy.play("idle")
		#if not is_attacking:
			#if direction == 0 and y_direction == 0:
				#enemy.play("idle")
			#else:
				#enemy.play("walk")
		#pass
		move_and_slide()
		var relative_position = position - last_position

		if relative_position.x < 0:
			facing_left = true
		elif relative_position.x > 0:
			facing_left = false

		enemy.flip_h = facing_left
		last_position = position


func animated_hit() -> void:
	is_hitted = 1
		
	enemy.flip_h = not facing_left
	if stats.health == 10:
		enemy.play("critic hitted")
	else:
		enemy.play("hitted")
	cooldown_timer.start()
	
	if stats.health == 0:
		enemy.play("die")
		is_alive = 0
		
#func attack() -> void:
	#can_attack = false
	#is_attacking = true
	#enemy.play("punch")
	#print("punch")
	#cooldown_timer.start()
#
#
func _on_timer_timeout() -> void:
	is_hitted = 0
	#can_attack = true
	#is_attacking = false
	#
	#enemy.play("idle")
	#print("done")



func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
