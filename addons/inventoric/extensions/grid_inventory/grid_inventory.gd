@icon("res://addons/inventoric/sprites/grid_inventory_icon.svg")
class_name ICGridInventory extends "res://addons/inventoric/core/base/inventory.gd"

signal item_added(to: Vector2i, item: ICItem)
signal item_removed(from: Vector2i)
signal item_moved(from: Vector2i, to: Vector2i, item: ICItem)

@export var config: ICGridInventoryConfig

var _item_collection: ICGridCollection

func add_item(slot: Vector2i, item: ICItemConfig) -> void:
	assert(_item_collection.get_item(slot) == null, "This item slot not empty.")
	assert(item != null, "Item config required")
	var item_instance = ICItem.new(item)
	_item_collection.set_item(slot, item_instance)
	item_added.emit(slot, item_instance)

func get_item(slot: Vector2i) -> ICItem:
	return _item_collection.get_item(slot)

func remove_item(slot: Vector2i) -> void:
	_item_collection.set_item(slot, null)
	item_removed.emit(slot)

func swap_items(from: Vector2i, to: Vector2i) -> void:
	if not config.allow_item_swap:
		return
	
	var from_item = _item_collection.get_item(from)
	var to_item = _item_collection.get_item(to)
	_item_collection.set_item(to, from_item)
	if from_item != null:
		item_moved.emit(from, to, from_item)
	_item_collection.set_item(from, to_item)
	if to_item != null:
		item_moved.emit(to, from, to_item)
	
func get_item_collection() -> ICGridCollection:
	return _item_collection

func _ready() -> void:
	assert(config != null, "Inventory config must be set.")
	
	_item_collection = ICGridCollection.new(Vector2i(config.size_h, config.size_v))
