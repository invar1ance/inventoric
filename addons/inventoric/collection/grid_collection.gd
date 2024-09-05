class_name ICGridCollection extends ICBaseCollection

## A collection class that manages items in a 2D grid layout.
## Extends ICBaseCollection to support conversion between 2D grid positions and 1D indices.

var _size: Vector2i

## Initializes the collection with a specified 2D (grid) [param size].
func _init(size: Vector2i) -> void:
	super._init(size.x * size.y)
	_size = size

## Converts a 2D (grid position) [param key] into a 1D [b]index[/b] based on the grid's width.
func flat_key(key: Vector2i) -> int:
	return key.y * _size.x + key.x

## Converts a 1D (index) [param idx] into a 2D [b]grid position[/b] based on the grid's width.
func grid_key(idx: int) -> Vector2i:
	return Vector2i(idx % _size.x, idx / _size.x)

## Sets an [param item] at the specified 2D (grid position) [param key] in the collection.
func set_item(key: Vector2i, value: Object) -> void:
	super.set_item(flat_key(key), value)

## Retrieves an [b]item[/b] from the specified (grid position) [param key] in the collection, or [code]null[code] if the (grid position) [param key] is invalid.
func get_item(key: Vector2i) -> Object:
	return super.get_item(flat_key(key))

## Checks if the collection contains the specified [param item] and return [code]true[/code] if the item exists, otherwise [code]false[/code].
func has_item(item: Object) -> bool:
	return super.has_item(item)

## Finds and return the first available ([code]null[/code] value) (grid position) key starting from the front of the collection ([i]left-to-right, top-to-bottom direction[/i]).
func get_free_key_front() -> Vector2i:
	return grid_key(super.get_free_key_front())

## Finds and return the first available ([code]null[/code] value) (grid position) key starting from the back of the collection ([i]left-to-right, top-to-bottom direction[/i]).
func get_free_key_back() -> Vector2i:
	return grid_key(super.get_free_key_back())

## Returns [code]true[/code] if the collection is empty (contains only [code]null[/code] values), otherwise [code]false[/code].
func is_empty() -> bool:
	return super.is_empty()

## Returns [code]true[/code] if the collection is full (not contains [code]null[/code] values), otherwise [code]false[/code].
func is_full() -> bool:
	return super.is_full()

## Returns an [Array] containing all the (grid position) [b]keys[/b] in the collection.
func keys() -> Array[Vector2i]:
	var keys: Array[Vector2i] = []
	for x in _size.x:
		for y in _size.y:
			keys.append(Vector2i(x, y))
			
	return keys

## Returns the 2D [b]size[/b] of the collection.
func size() -> Vector2i:
	return _size
