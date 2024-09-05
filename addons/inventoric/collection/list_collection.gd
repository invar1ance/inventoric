class_name ICListCollection extends "res://addons/inventoric/base/base_collection.gd"

## A collection class that manages items in a list layout.
## Extends ICBaseCollection to support index typization.

## Initializes the collection with a specified (list) [param size].
func _init(size: int) -> void:
	super._init(size)

## Sets an [param item] at the specified (list position) [param key] in the collection.
func set_item(key: int, value: Object) -> void:
	super.set_item(key, value)

## Retrieves an [b]item[/b] from the specified (list position) [param key] in the collection, or [code]null[code] if the (list position) [param key] is invalid.
func get_item(key: int) -> Object:
	return super.get_item(key)

## Checks if the collection contains the specified [param item] and return [code]true[/code] if the item exists, otherwise [code]false[/code].
func has_item(item: Object) -> bool:
	return super.has_item(item)
	
## Finds and return the first available ([code]null[/code] value) (list position) key starting from the front of the collection.
func get_free_key_front() -> int:
	return super.get_free_key_front()

## Finds and return the first available ([code]null[/code] value) (list position) key starting from the back of the collection.
func get_free_key_back() -> int:
	return super.get_free_key_back()
	
## Returns [code]true[/code] if the collection is empty (contains only [code]null[/code] values), otherwise [code]false[/code].
func is_empty() -> bool:
	return super.is_empty()

## Returns [code]true[/code] if the collection is full (not contains [code]null[/code] values), otherwise [code]false[/code].
func is_full() -> bool:
	return super.is_full()

## Returns an [Array] containing all the (list position) [b]keys[/b] in the collection.
func keys() -> Array[int]:
	return super.keys()

## Returns the [b]size[/b] of the collection.
func size() -> int:
	return super.size()

## Returns [code]true[/code] if the [param key] is valid for this collection, otherwise [code]false[/code].
func is_key_valid(key: int) -> bool:
	return super.is_key_valid(key)
