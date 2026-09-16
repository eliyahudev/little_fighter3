extends State

@export var idle_state: State
@export var die_state: State
var is_activate_state = false

func _ready() -> void:
	owner.stats.health_depleted.connect(die)

func update(_delta: float) -> void:
	is_activate_state = true
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") == Vector2.ZERO:
		is_activate_state = false
		switch_state.emit(idle_state)	
	
	if not _is_active_act():
		owner.walk()

func die() -> void:
	if is_activate_state:
		is_activate_state = false
		switch_state.emit(die_state)

func _is_active_act():
	return Input.is_action_just_pressed("defense") or \
		#Input.is_action_just_pressed("charge") or \
		Input.is_action_just_pressed("mealy-attack")
		
