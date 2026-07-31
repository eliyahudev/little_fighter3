extends State

var is_activate_state = false
var is_dead = false
#func _ready() -> void:
	#owner.something.connect(revive)
func enter_state() -> void:
	is_dead = true
func update(_delta: float) -> void:
	is_activate_state = true
	if not is_dead:
		owner.player_dead()

#func revive() -> void:
	#pass
