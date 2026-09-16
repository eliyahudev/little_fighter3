extends State

@export var idle_state: State
@export var walk_state: State
@export var MIN_STATE_TIME: float = 0.1
@export var SHORT_TIME_ACT: float = 0.5
@export var LONG_TIME_ACT: float = 0.3

var is_activate_state = false
var time_expled = 0.0
var animation_delay = 0.0

func update(_delta: float) -> void:
	is_activate_state = true
	
func _process(delta: float) -> void:
	if not is_activate_state:
		return
	time_expled += delta
	#print("[DEBIG] static_action.gd DEAD END time_expled: ", time_expled)
	owner.walk()
	if time_expled < LONG_TIME_ACT:
		animation_delay += delta
		owner.dynamic_act_animation(time_expled, MIN_STATE_TIME)

		if animation_delay > 0.2:
			owner.dynamic_act(time_expled, MIN_STATE_TIME + 0.2)
	
	if not owner.walk_pressed():
		switch_state.emit(idle_state)
		is_activate_state = false
		time_expled = 0.0 
			
	if not owner.action_pressed() and time_expled > SHORT_TIME_ACT + 0.2:

		#print("[DEBUG] no action_pressed static_action.gd DEAD END")
		is_activate_state = false
		time_expled = 0.0 

		if not owner.walk_pressed():
			switch_state.emit(idle_state)	
		else:
			switch_state.emit(walk_state)	
					

		
