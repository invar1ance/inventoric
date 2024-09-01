class_name ICBaseCollection

## A base class for managing a collection of items, providing functionality to add, 
## retrieve, and check items within a fixed-size array.

## Collection of items
var _items: Array 

## Initializes the collection with a specified [param size].
func _init(size: int) -> void:
	_items = []
	_items.resize(size)

## Sets an [param item] at the specified [param key] in the collection.
func set_item(key, item) -> void:
	if not is_key_valid(key):
		return
		
	_items[key] = item

## Retrieves an [code]item[/code] from the specified [param key] in the collection, or [code]null[code] if the key is invalid.
func get_item(key) -> Object:
	if not is_key_valid(key):
		return null
	
	return _items[key]

## Checks if the collection contains the specified [param item] and return [code]true[/code] if the item exists, otherwise [code]false[/code].
func has_item(item) -> bool:
	return _items.has(item)

## Finds and return the first available ([code]null[/code] value) [code]key[/code] starting from the front of the collection.
func get_free_key_front() -> Variant:
	for key in _items.size():
		if _items[key] == null:
			return key
		
	return -1

## Finds and return the first available ([code]null[/code] value) [code]key[/code] starting from the back of the collection.
func get_free_key_back() -> Variant:
	for key in range(_items.size(), 0, -1):
		if _items[key] == null:
			return key
		
	return -1

## Returns [code]true[/code] if the collection is empty (contains only [code]null[/code] values), otherwise [code]false[/code].
func is_empty() -> bool:
	for value in _items:
		if value != null:
			return false
			
	return true

## Returns [code]true[/code] if the collection is full (not contains [code]null[/code] values), otherwise [code]false[/code].
func is_full() -> bool:
	return not _items.has(null)

## Returns an array containing all the [b]values[/b] in the collection.
func values() -> Array:
	return _items
	
## Returns an [Array] containing all the [b]keys[/b] in the collection.
func keys() -> Array:
	return range(0, _items.size)

## Returns the [b]size[/b] of the collection.
func size() -> Variant:
	return _items.size()

## Returns the count of non-empty ([code]!= null[/code]) items in the collection.
func length() -> int:
	return _items.filter(func(key) -> bool: return key != null).size()

## Returns [code]true[/code] if the [param key] is valid for this collection, otherwise [code]false[/code].
func is_key_valid(key) -> bool:
	return key >= 0 and key < _items.size()
