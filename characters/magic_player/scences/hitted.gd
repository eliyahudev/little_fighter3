extends State

@export var idle_state: State
@export var MIN_STATE_TIME: float = 0.1
@export var SHORT_TIME_ACT: float = 0.5
@export var LONG_TIME_ACT: float = 0.3

var is_activate_state = false
var time_expeld = 0.0

func update(_delta: float) -> void:
	is_activate_state = true
	
func _process(delta: float) -> void:
	if not is_activate_state:
		return
	time_expeld += delta
	#print("[DEBIG] static_action.gd DEAD END time_expeld: ", time_expeld)
	if time_expeld < LONG_TIME_ACT:
		owner.hitted_animation()
		owner.hitted()
	else:
		is_activate_state = false
		time_expeld = 0.0 
		switch_state.emit(idle_state)	
		
