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
	
	owner.walk()

func die() -> void:
	if is_activate_state:
		is_activate_state = false
		switch_state.emit(die_state)
