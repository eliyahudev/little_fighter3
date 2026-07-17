extends CharacterBody2D

@export var stats: Stats
@export var hitbox_shape: Shape2D

const SPEED = 100.0

var last_direction := Vector2.RIGHT

@onready var animated_sprite_lord_db: AnimatedSprite2D = $lord_animation_test
@onready var attack_skill: PlayerAttackSkill = $SkillControllers/AttackSkill
@onready var defense_skill: PlayerDefenseSkill = $SkillControllers/DefenseSkill
@onready var charge_skill: PlayerChargeSkill = $SkillControllers/ChargeSkill

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
	return not defense_skill.is_active() and not charge_skill.is_active()

func can_start_defense() -> bool:
	return not attack_skill.is_active() and not charge_skill.is_active()

func can_start_charge() -> bool:
	return not attack_skill.is_active() and not defense_skill.is_active()

func is_skill_active() -> bool:
	return attack_skill.is_active() or defense_skill.is_active() or charge_skill.is_active()

func is_movement_blocked() -> bool:
	return charge_skill.blocks_movement()

func _update_facing(input_direction: Vector2) -> void:
	if input_direction == Vector2.ZERO:
		return

	last_direction = input_direction

	if input_direction.x < 0:
		animated_sprite_lord_db.flip_h = true
	elif input_direction.x > 0:
		animated_sprite_lord_db.flip_h = false

	
