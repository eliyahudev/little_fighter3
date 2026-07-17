extends State

@export var move_state: State

func update(_delta: float) -> void:
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO:
	#if owner.position != Vector2.ZERO:
		switch_state.emit(move_state)	
