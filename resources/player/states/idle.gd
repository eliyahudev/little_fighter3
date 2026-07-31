extends State

@export var move_state: State
@export var die_state: State
var is_activate_state = false

func _ready() -> void:
	owner.stats.health_depleted.connect(die)

func update(_delta: float) -> void:
	is_activate_state = true
	owner.player_idle()
	
func _on_player_walk_pressed() -> void:
	switch_state.emit(move_state)	

func die() -> void:
	if is_activate_state:
		is_activate_state = false
		switch_state.emit(die_state)
