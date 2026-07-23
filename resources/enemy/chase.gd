extends State

@export var player : CharacterBody2D = null
@export var wait_state: State = null
@export var die_state: State = null
var player_lost : bool = true
var is_dead_state := false
var is_activate_state = false

func _ready() -> void:
	player.stats.health_depleted.connect(die)
	
func update(_delta: float) -> void:
	is_activate_state = true
		
	player.chase_player()
	if player.is_player_in_range():
		player.activate_battle_mode()
		
	player.move_and_slide()

func die() -> void:
	if is_activate_state:
		is_activate_state = false
		switch_state.emit(die_state)
	
func _on_detection_area_body_exited(body: Node2D) -> void:
	if is_activate_state:
		is_activate_state = false
		switch_state.emit(wait_state)
