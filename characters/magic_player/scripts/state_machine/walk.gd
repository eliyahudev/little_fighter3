extends State

@export var idle_state: State
@export var dyn_act_state: State

var is_activate_state = false


func update(_delta: float) -> void:
	is_activate_state = true
	
func _process(delta: float) -> void:
	if not is_activate_state:
		return
		
	owner.walk()
	owner.walk_animation()
	
	if not owner.walk_pressed():
		print("[DEBUG] no walk_pressed walk.gd DEAD END")
		is_activate_state = false
		switch_state.emit(idle_state)	

	if owner.action_pressed():
		print("[DEBUG] action_pressed walk.gd")
		is_activate_state = false
		switch_state.emit(dyn_act_state)	
