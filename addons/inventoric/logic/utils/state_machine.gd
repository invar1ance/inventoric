class_name StateMachine

signal entered(from, to)

var _state
var _states: Dictionary
var _subscribes: Dictionary

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
	if not can(to):
		push_error("Invalid transition from %s to %s" % [_state, to])
		return
	
	entered.emit(_state, to)
	_state = to
	
func has(state) -> bool:
	return _state == state
