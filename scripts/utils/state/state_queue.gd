extends Queue


func queue_state_input(state: State) -> void:
	if state == null:
		return

	# Map your input actions here
	if state.name == "attack" or state.name == "charge" or state.name == "defense":
		_add_to_queue(state.name)
