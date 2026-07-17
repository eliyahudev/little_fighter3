extends State

@export var idle_state: State
@export var skill_path: NodePath

@onready var skill: PlayerDefenseSkill = get_node(skill_path)

func enter_state() -> void:
	if not skill.start():
		switch_state.emit(idle_state)

func exit_state() -> void:
	skill.stop()

func update(_delta: float) -> void:
	if Input.is_action_pressed("defense"):
		return

	skill.stop()
	switch_state.emit(idle_state)	
