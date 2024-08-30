class_name ICGridCollection extends ICBaseCollection

var _size: Vector2i

func _init(size: Vector2i) -> void:
	super._init(size.x * size.y)
	_size = size

func flat_key(grid_position: Vector2i) -> int:
	return grid_position.y * _size.x + grid_position.x
	
func grid_key(idx: int) -> Vector2i:
	return Vector2i(idx % _size.x, idx / _size.x)

func set_item(key: Vector2i, value: Object) -> void:
	super.set_item(flat_key(key), value)
	
func get_item(key: Vector2i) -> Object:
	return super.get_item(flat_key(key))

func has_item(item: Object) -> bool:
	return super.has_item(item)
	
func get_free_key_front() -> Vector2:
	return grid_key(super.get_free_key_front())

func get_free_key_back() -> Vector2:
	return grid_key(super.get_free_key_back())
	
func is_empty() -> bool:
	return super.is_empty()
	
func is_full() -> bool:
	return super.is_full()
	
func values() -> Array:
	return super.values()
	
func keys() -> Array[Vector2i]:
	var keys: Array[Vector2i] = []
	for x in _size.x:
		for y in _size.y:
			keys.append(Vector2i(x, y))
			
	return keys

func size() -> Vector2i:
	return _size
