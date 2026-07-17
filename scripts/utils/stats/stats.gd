class_name Stats extends Resource

enum Faction {
	PLAYER,
	ENEMY
}

signal health_changed(cur_health: int, max_health: int) 
signal health_depleted

@export var health: int = 10
@export var defense: int = 1
@export var attack: int = 1
@export var faction : Faction = Faction.PLAYER
@export var SPEED = 40.0
@export var JUMP_VELOCITY = -400.0
@export var MAX_HEALTH = 10.0

var current_health : int : set = _on_health_set
var current_max_health: int = health


func _init() -> void:
	initialize_stats.call_deferred()
	
func initialize_stats()->void:
	#recalculate_stats()
	current_health = health

func take_demage(amount : int) -> void:
	current_health -= amount

func _on_health_set(new_value: int) -> void:
	health = clampi(new_value,0,current_max_health)
	
	health_changed.emit(health, current_max_health)
	if health <=0:
		health_depleted.emit()
	
	current_health = health
