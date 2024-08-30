class_name ICInventory extends Node

signal initialized
signal inventory_filled

var is_initialized: bool = false

func add_item(slot, item: ICItemConfig) -> void:
	pass

func get_item(slot) -> ICItem:
	return null

func remove_item(slot) -> void:
	pass

func swap_items(from, to) -> void:
	pass

func get_item_collection() -> ICBaseCollection:
	return null
