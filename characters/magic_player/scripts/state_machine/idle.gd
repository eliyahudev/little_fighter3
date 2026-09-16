extends State

@export var move_state: State
@export var static_act_state: State
@export var hurt_state_state: State

var is_activate_state = false


func update(_delta: float) -> void:
	is_activate_state = true
	
func _process(delta: float) -> void:
	if not is_activate_state:
		return
	owner.idle()
	if owner.walk_pressed():
		print("[DEBUG] walk_pressed idle.gd")
		is_activate_state = false
		switch_state.emit(move_state)	
	
	if owner.action_pressed():
		print("[DEBUG] action_pressed idle.gd")
		is_activate_state = false
		switch_state.emit(static_act_state)	
		


func _on_hurtbox_owner_hit() -> void:
	is_activate_state = false
	switch_state.emit(hurt_state_state)	
	print("[DEBUG] HITTED idle.gd")
	pass # Replace with function body.
