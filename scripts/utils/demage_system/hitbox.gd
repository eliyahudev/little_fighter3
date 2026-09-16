class_name hitbox extends Area2D

var attacker_stats: Stats
var hitbox_lifetime: float
var shape: Shape2D
var hit_log: HitLog

func _init(_attacker_stats, _hitbox_lifetime, _shape, _hitlog=null) -> void:
	attacker_stats = _attacker_stats
		
	hitbox_lifetime = _hitbox_lifetime
	shape = _shape
	hit_log = _hitlog
func _ready() -> void:
	monitorable = false
	area_entered.connect(_on_area_entered)
	 
	if hitbox_lifetime > 0.0:
		var new_timer = Timer.new()
		add_child(new_timer)
		new_timer.timeout.connect(queue_free)
		new_timer.call_deferred("start", hitbox_lifetime)

	if shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape 
		add_child(collision_shape)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(2, false)
	set_collision_mask_value(2, false)

	
	match attacker_stats.faction:
		Stats.Faction.ENEMY:
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)
		Stats.Faction.PLAYER:
			set_collision_layer_value(2, true)
			set_collision_mask_value(2, true)
	
func _on_area_entered(area:Area2D)	-> void:
	print(area.name)
	if not area.has_method("recive_hit"):
		return
	
	var hurtbox_owner = area.owner
	if hit_log:  
		if hit_log.has_hit(hurtbox_owner):
			return
		else:
			hit_log.log_hit(hurtbox_owner)
	var demage = attacker_stats.attack
	print("[DEBUG] hitbox.gd | demage = ", demage)
	if randf_range(0,1) < 0.1:
		demage *= 1.1  
	area.recive_hit(demage)
