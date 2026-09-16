extends State

@export var idle_state: State
@export var die_state: State
@export var passive_sm: StateMachine

var is_activate_state = false

func _ready() -> void:
	owner.stats.health_depleted.connect(die)

func update(_delta: float) -> void:
	is_activate_state = true
	
	#if passive_sm.active_state.name == name:
	print("passive_sm.active_state: ", passive_sm.active_state.name)
	if passive_sm.active_state.state_lock:
		print(name)
		_idle()
	
func _idle() -> void:
	# is_activate_state = false
	switch_state.emit(idle_state)	
	passive_sm.disable_sm()	
	
func die() -> void:
	if is_activate_state:
		is_activate_state = false
		switch_state.emit(die_state)
