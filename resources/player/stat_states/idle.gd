extends State

@export var attack_state: State
@export var defense_state: State
@export var charge_state: State



func update(_delta: float) -> void:

	if Input.is_action_just_pressed("defense"):
		switch_state.emit(defense_state)	
		return

	if Input.is_action_just_pressed("charge"):
		switch_state.emit(charge_state)


func _on_player_attack_pressed() -> void:
	switch_state.emit(attack_state)	
	
