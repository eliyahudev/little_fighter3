class_name PlayerAttackSkill extends Node

@export var player_path: NodePath
@export var cooldown_time := 0.255
@export var hitbox_lifetime := 0.3
@export var hitbox_offset := Vector2(10, 5)
@export var hitbox_scale := Vector2(0.5, 1)

var _active := false
var _cooling_down := false
var _run_id := 0

@onready var player = get_node(player_path)

func can_start() -> bool:
	return not _active and not _cooling_down and player.can_start_attack()

func start() -> bool:
	if not can_start():
		return false

	_active = true
	_cooling_down = true
	_run_id += 1
	var current_run_id := _run_id

	player.play_animation("punch")
	var facing_offset := Vector2(hitbox_offset.x * player.get_facing_sign(), hitbox_offset.y)
	player.spawn_hitbox(hitbox_lifetime, facing_offset, hitbox_scale)
	_finish_after_cooldown(current_run_id)
	return true

func is_active() -> bool:
	return _active

func stop() -> void:
	_active = false

func _finish_after_cooldown(run_id: int) -> void:
	await get_tree().create_timer(cooldown_time).timeout

	if run_id != _run_id:
		return

	_active = false
	_cooling_down = false
