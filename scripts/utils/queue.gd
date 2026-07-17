# input_queue.gd
extends Node
class_name Queue

@export var max_queue_size: int = 4
@export var input_buffer_time: float = 0.35 # Time in seconds before a stored move expires

# The queue stores dictionaries containing the move name and timestamps
var queue: Array[Dictionary] = []

func _process(_delta: float) -> void:
	_clear_expired_inputs()

# Adds a new move to the back of the queue
func _add_to_queue(move_name: String) -> void:
	# If queue is full, remove the oldest input to make room
	if queue.size() >= max_queue_size:
		#print("queue", queue)
		queue.pop_front()
	
	var new_input = {
		"move": move_name,
		"timestamp": Time.get_ticks_msec() / 1000.0
	}
	queue.append(new_input)

# Automatically drops inputs that the player pressed too long ago
func _clear_expired_inputs() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	while queue.size() > 0:
		if current_time - queue[0]["timestamp"] > input_buffer_time:
			queue.pop_front() # Remove expired oldest move
		else:
			break # Since they are chronological, if the first isn't expired, others aren't either

# Checks if a specific move is next in line without removing it
func peek_next_move() -> String:
	if queue.size() > 0:
		return queue[0]["move"]
	return ""

# Consumes (removes and returns) the next move in line
func pop_next_move() -> String:
	if queue.size() > 0:
		var next_input = queue.pop_front()
		return next_input["move"]
	return ""

# Clears everything (useful if the player gets stunned/hit)
func clear_all() -> void:
	queue.clear()
