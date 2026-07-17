class_name PlayerChargeSkill extends Node

@export var player_path: NodePath
@export var startup_time := 0.25
@export var hitbox_lifetime := 0.7
@export var left_hitbox_offset := Vector2(-10, 5)
@export var right_hitbox_offset := Vector2(10, 5)
@export var left_hitbox_scale := Vector2(0.5, 1)
@export var right_hitbox_scale := Vector2.ONE

var _active := false
var _run_id := 0

@onready var player = get_node(player_path)

func can_start() -> bool:
	return not _active and player.can_start_charge()

func start() -> bool:
	if not can_start():
		return false

	_active = true
	_run_id += 1
	var current_run_id := _run_id

	player.play_animation("charge")
	player.spawn_hitbox(hitbox_lifetime, left_hitbox_offset, left_hitbox_scale)
	player.spawn_hitbox(hitbox_lifetime, right_hitbox_offset, right_hitbox_scale)
	hold_after_startup(current_run_id)
	return true

func stop() -> void:
	if not _active:
		return

	_active = false
	_run_id += 1

func is_active() -> bool:
	return _active

func blocks_movement() -> bool:
	return _active

func hold_after_startup(run_id: int) -> void:
	await get_tree().create_timer(startup_time).timeout

	if _active and run_id == _run_id:
		player.play_animation("charge_idle")
