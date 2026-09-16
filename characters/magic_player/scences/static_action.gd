extends State

@export var idle_state: State
@export var douge_state_state: State
@export var MIN_STATE_TIME: float = 0.1
@export var SHORT_TIME_ACT: float = 0.5
@export var LONG_TIME_ACT: float = 0.3
var is_activate_state = false
var time_expeld = 0.0
var animation_delay = 0.0

func update(_delta: float) -> void:
	is_activate_state = true
	
func _process(delta: float) -> void:
	if not is_activate_state:
		return
	time_expeld += delta
	#print("[DEBIG] static_action.gd DEAD END time_expeld: ", time_expeld)
	if time_expeld < LONG_TIME_ACT:
		animation_delay += delta
		owner.static_act_animation(time_expeld, MIN_STATE_TIME)
		if animation_delay > 0.1:
			owner.static_act(time_expeld, MIN_STATE_TIME + 0.1)
	
	if not owner.action_pressed() and time_expeld > LONG_TIME_ACT:
		owner.stop_static_act_animation()
		#print("[DEBUG] no action_pressed static_action.gd DEAD END")
		is_activate_state = false
		time_expeld = 0.0 
		animation_delay = 0.0

		switch_state.emit(idle_state)	
		


func _on_hurtbox_owner_douge() -> void:
	is_activate_state = false
	time_expeld = 0.0 
	animation_delay = 0.0	
	switch_state.emit(douge_state_state)	
