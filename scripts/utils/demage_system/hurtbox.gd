class_name Hurtbox extends Area2D

@export var skill_state : StateMachine = null
@export var cooldown_time : float = 1.0
@onready var owner_stats: Stats = owner.stats
signal owner_hit
signal owner_douge

var is_prevent_demage = false
var _cooling_down := false

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
	if not is_prevent_demage and not _cooling_down:
		print("[DEBUG] player recive a hit! | hurtbox.gd")
		_finish_after_cooldown()
		owner_hit.emit()
		owner_stats.take_demage(demage)
	elif is_prevent_demage:
		owner_douge.emit()

func defend_character():
	is_prevent_demage = true
	print("[DEBUG] start defening | hurtbox.gd")
	
func stop_defend_character():
	is_prevent_demage = false
	print("[DEBUG] stop defending | hurtbox.gd")
	
func _finish_after_cooldown() -> void:
	_cooling_down = true
	var attack_timer = get_tree().create_timer(cooldown_time)
	attack_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	_cooling_down = false
