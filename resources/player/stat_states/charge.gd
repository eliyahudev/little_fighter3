extends State

@export var idle_state: State

func update(_delta: float) -> void:
	if Input.is_action_pressed("charge"):
		return

	switch_state.emit(idle_state)	
