extends State

@export var idle_state: State
@export var skill_path: NodePath

@onready var skill: PlayerAttackSkill = get_node(skill_path)

func enter_state() -> void:
	if not skill.start():
		switch_state.emit(idle_state)

func update(_delta: float) -> void:
	if not skill.is_active():
		switch_state.emit(idle_state)
