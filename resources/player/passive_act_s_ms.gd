extends StateMachine

#signal state_changed(previous_state: State, active_state: State)
#
#@export var initial_state: State
#
var is_state_enable2: bool = false
#var active_state2: State

func _ready() -> void:
	for child_state: State in get_children():
		child_state.switch_state.connect(change_state)
	change_state(initial_state)

func _process(delta: float) -> void:
	if active_state:
		print("[DEBUG] ACT SM active_state: ", active_state.name)
		active_state.update(delta)
		
		
func _physics_process(delta: float) -> void:
	if active_state:
		active_state.physics_update(delta)
	
func change_state(new_state:State) -> void:
	if new_state == active_state and not is_state_enable2:
		return

	var previous_state := active_state

	if active_state:
		active_state.exit_state()
	
	active_state = new_state

	if active_state:
		active_state.enter_state()

	state_changed.emit(previous_state, active_state)

func enable_sm() -> void:
	is_state_enable2 = true

func disable_sm() -> void:
	is_state_enable2 = false
