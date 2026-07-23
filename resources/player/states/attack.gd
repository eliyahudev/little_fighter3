extends State

@export var idle_state: State
@export var state_duration := 0.255

var _elapsed_time := 0.0

func enter_state() -> void:
	_elapsed_time = 0.0

func update(_delta: float) -> void:
	_elapsed_time += _delta

	if _elapsed_time >= state_duration:
		switch_state.emit(idle_state)
