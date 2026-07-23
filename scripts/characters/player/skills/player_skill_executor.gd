class_name PlayerSkillExecutor extends Node

@export var state_machine: StateMachine
@export var attack_skill: PlayerAttackSkill
@export var defense_skill: PlayerDefenseSkill
@export var charge_skill: PlayerChargeSkill
@export var hurt_duration := 0.4

var _is_hurt := false
var _is_dead := false
var _hurt_run_id := 0

@onready var player = get_parent().get_parent()

func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)
	_on_state_changed(null, state_machine.active_state)

func is_skill_active() -> bool:
	return _is_hurt or _is_dead or attack_skill.is_active() or defense_skill.is_active() or charge_skill.is_active()

func is_movement_blocked() -> bool:
	return _is_hurt or _is_dead or charge_skill.blocks_movement()

func is_attack_active() -> bool:
	return attack_skill.is_active()

func is_defense_active() -> bool:
	return defense_skill.is_active()

func is_charge_active() -> bool:
	return charge_skill.is_active()

func is_hurt() -> bool:
	return _is_hurt

func is_dead() -> bool:
	return _is_dead

func handle_hit() -> void:
	if _is_dead:
		return

	_stop_all_skills()
	_hurt_run_id += 1

	if player.stats.health <= 0:
		_is_dead = true
		_is_hurt = false
		player.play_animation("die")
		return

	_is_hurt = true
	if player.stats.health <= player.stats.current_max_health / 10.0:
		player.play_animation("critic hitted")
	else:
		player.play_animation("hitted")

	_finish_hurt(_hurt_run_id)

func _on_state_changed(previous_state: State, active_state: State) -> void:
	_stop_state_skill(previous_state)
	_start_state_skill(active_state)

func _start_state_skill(state: State) -> void:
	if state == null or _is_hurt or _is_dead:
		return

	match state.name:
		"attack":
			attack_skill.start()
		"defense":
			defense_skill.start()
		"charge":
			charge_skill.start()

func _stop_state_skill(state: State) -> void:
	if state == null:
		return

	match state.name:
		"attack":
			attack_skill.stop()
		"defense":
			defense_skill.stop()
		"charge":
			charge_skill.stop()

func _stop_all_skills() -> void:
	attack_skill.stop()
	defense_skill.stop()
	charge_skill.stop()

func _finish_hurt(run_id: int) -> void:
	await get_tree().create_timer(hurt_duration).timeout

	if run_id != _hurt_run_id or _is_dead:
		return

	_is_hurt = false
	_start_state_skill(state_machine.active_state)
