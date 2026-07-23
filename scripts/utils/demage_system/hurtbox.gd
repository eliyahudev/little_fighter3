class_name Hurtbox extends Area2D

@export var skill_state : StateMachine = null

@onready var owner_stats: Stats = owner.stats
signal owner_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	
	match owner_stats.faction:
		Stats.Faction.PLAYER:
			set_collision_layer_value(1, true)
		Stats.Faction.ENEMY:
			set_collision_layer_value(2, true)
	
func recive_hit(demage:int) ->void:
	if skill_state.active_state != null:
		print("skill_state.active_state name: ", skill_state.active_state.name)
		if skill_state.active_state.name != "defense":
			owner_hit.emit()
			owner_stats.take_demage(demage)
