extends State

@export var idle_state: State
@export var state_duration := 0.255
@export var attack_skill : PlayerAttackSkill

var _elapsed_time := 0.0

func enter_state() -> void:
	_elapsed_time = 0.0

func update(_delta: float) -> void:
	state_lock = true
	_elapsed_time += _delta
	owner.skill_executor.attack_skill.start(state_duration)
	#_start_state_skill SHOULD BE ATTACK HERE
	
	if _elapsed_time >= state_duration:
		switch_state.emit(idle_state)

	#attack_skill.start()
