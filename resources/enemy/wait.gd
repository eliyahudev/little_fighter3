extends State

@export var player : CharacterBody2D = null
@export var chase_state: State = null
var is_activate_state = false
var player_detected : bool = false

func update(_delta: float) -> void:
	is_activate_state = true
	player.idle_player()
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	if is_activate_state:
		is_activate_state = false
		switch_state.emit(chase_state)
