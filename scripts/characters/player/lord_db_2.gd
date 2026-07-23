class_name Player extends CharacterBody2D

@export var stats: Stats
@export var hitbox_shape: Shape2D
@export var animated_sprite_lord_db: AnimatedSprite2D
const SPEED = 100.0

var last_direction := Vector2.RIGHT

#@onready var animated_sprite_lord_db: AnimatedSprite2D = $lord_animation_test
@onready var skill_executor: PlayerSkillExecutor = $SkillControllers/SkillExecutor
@onready var hurtbox: Hurtbox = $Hurtbox

func _ready() -> void:
	hurtbox.owner_hit.connect(_take_demage)

func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	_update_facing(input_direction)
	velocity = Vector2.ZERO if is_movement_blocked() else input_direction * SPEED

	if not is_skill_active():
		play_animation("idle" if input_direction == Vector2.ZERO else "walk")

	move_and_slide()

func play_animation(animation_name: StringName) -> void:
	if animated_sprite_lord_db.animation == animation_name and animated_sprite_lord_db.is_playing():
		return

	animated_sprite_lord_db.play(animation_name)

func spawn_hitbox(hitbox_lifetime: float, offset: Vector2, hitbox_scale := Vector2.ONE) -> Area2D:
	var hitbox_area := hitbox.new(stats, hitbox_lifetime, hitbox_shape)
	hitbox_area.position = offset
	hitbox_area.scale = hitbox_scale
	add_child(hitbox_area)
	return hitbox_area

func get_facing_sign() -> int:
	return -1 if animated_sprite_lord_db.flip_h else 1

func can_start_attack() -> bool:
	return not skill_executor.is_hurt() and not skill_executor.is_dead() and not skill_executor.is_defense_active() and not skill_executor.is_charge_active()

func can_start_defense() -> bool:
	return not skill_executor.is_hurt() and not skill_executor.is_dead() and not skill_executor.is_attack_active() and not skill_executor.is_charge_active()

func can_start_charge() -> bool:
	return not skill_executor.is_hurt() and not skill_executor.is_dead() and not skill_executor.is_attack_active() and not skill_executor.is_defense_active()

func is_skill_active() -> bool:
	return skill_executor.is_skill_active()

func is_movement_blocked() -> bool:
	return skill_executor.is_movement_blocked()

func _update_facing(input_direction: Vector2) -> void:
	if input_direction == Vector2.ZERO:
		return

	last_direction = input_direction

	if input_direction.x < 0:
		animated_sprite_lord_db.flip_h = true
	elif input_direction.x > 0:
		animated_sprite_lord_db.flip_h = false

func animated_hit() -> void:
	skill_executor.handle_hit()

func _take_demage():
	animated_hit()
