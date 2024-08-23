class_name Collection

var _elements: Array

func _init(size: int) -> void:
	_elements = []
	_elements.resize(size)

func set_element(idx: int, element: Object) -> void:
	if not _validate_idx(idx):
		return
		
	_elements[idx] = element
	
func get_element(idx: int) -> Object:
	if not _validate_idx(idx):
		return null
	
	return _elements[idx]
	
func size() -> int:
	return _elements.size()
	
func has(element) -> bool:
	return _elements.has(element)
	
func all() -> Array:
	return _elements

func _validate_idx(idx: int) -> bool:
	if idx >= _elements.size() or idx < 0:
		push_error("Invalid grid index: %d" % idx)
		return false
		
	return true
