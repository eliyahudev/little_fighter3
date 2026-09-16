class_name PlayerAttackSkill extends Node

@export var player_path: NodePath
@export var cooldown_time := 0.255
@export var hitbox_lifetime := 0.3
@export var hitbox_offset := Vector2(10, 5)
@export var hitbox_scale := Vector2(0.5, 1)
@export var hitbox_shape: Shape2D

var _cooling_down := false

@onready var player = get_node(player_path)

func start(state_duration: int) -> bool:
	if _cooling_down:
		return false
	
	_finish_after_cooldown()
	
	player.play_animation("punch")
	var facing_offset := Vector2(hitbox_offset.x * player.get_facing_sign(), hitbox_offset.y)
	#player.spawn_hitbox(hitbox_lifetime, facing_offset, hitbox_scale)
	spawn_hitbox(state_duration, facing_offset, hitbox_scale)
	
	return true

func spawn_hitbox(hitbox_lifetime: float, offset: Vector2, hitbox_scale := Vector2.ONE) -> Area2D:
	var hitbox_area := hitbox.new(owner.stats, hitbox_lifetime, hitbox_shape)
	hitbox_area.position = offset
	hitbox_area.scale = hitbox_scale
	add_child(hitbox_area)
	return hitbox_area


func _finish_after_cooldown() -> void:
	_cooling_down = true
	var attack_timer = get_tree().create_timer(cooldown_time)
	attack_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	_cooling_down = false
