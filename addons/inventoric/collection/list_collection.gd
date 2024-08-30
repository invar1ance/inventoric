class_name ICListCollection extends ICBaseCollection

func _init(size: int) -> void:
	super._init(size)

func set_item(key: int, value: Object) -> void:
	super.set_item(key, value)
	
func get_item(key: int) -> Object:
	return super.get_item(key)

func has_item(item: Object) -> bool:
	return super.has_item(item)
	
func get_free_key_front() -> int:
	return super.get_free_key_front()

func get_free_key_back() -> int:
	return super.get_free_key_back()
	
func is_empty() -> bool:
	return super.is_empty()
	
func is_full() -> bool:
	return super.is_full()
	
func get_values() -> Array:
	return super.values()
	
func get_keys() -> Array[int]:
	return super.keys()
	
func size() -> int:
	return super.size()

func is_key_valid(key: int) -> bool:
	return super.is_key_valid(key)
