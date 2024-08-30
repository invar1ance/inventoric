class_name ICBaseCollection

var _items: Array

func _init(size: int) -> void:
	_items = []
	_items.resize(size)

func set_item(key, value) -> void:
	if not is_key_valid(key):
		return
		
	_items[key] = value
	
func get_item(key) -> Object:
	if not is_key_valid(key):
		return null
	
	return _items[key]

func has_item(item) -> bool:
	return _items.has(item)
	
func get_free_key_front() -> Variant:
	for key in _items.size():
		if _items[key] == null:
			return key
		
	return -1

func get_free_key_back() -> Variant:
	for key in range(_items.size(), 0, -1):
		if _items[key] == null:
			return key
		
	return -1
	
func is_empty() -> bool:
	for value in _items:
		if value != null:
			return false
			
	return true
	
func is_full() -> bool:
	return not _items.has(null)
	
func values() -> Array:
	return _items
	
func keys() -> Array:
	return range(0, _items.size)
	
func size() -> Variant:
	return _items.size()

func is_key_valid(key) -> bool:
	return key >= 0 and key < _items.size()
