class_name Flow

signal entered(to)

var _state
var _states: Dictionary

func _init(state) -> void:
	_state = state

func add_transition(from, to) -> void:
	if _states.has(from):
		_states[from].append(to)
	else:
		_states[from] = [to]

func can(to) -> bool:
	return (_states.has(_state) and _states[_state].has(to)) || (to == _state)

func apply(to) -> void:
	if can(to):
		_state = to
		entered.emit(to)

func has(state) -> bool:
	return _state == state
