class_name PlayerDefenseSkill extends Node

@export var player_path: NodePath

var _active := false

@onready var player = get_node(player_path)

func can_start() -> bool:
	return not _active and player.can_start_defense()

func start() -> bool:
	if not can_start():
		return false

	_active = true
	player.play_animation("defense")
	return true

func stop() -> void:
	_active = false

func is_active() -> bool:
	return _active
