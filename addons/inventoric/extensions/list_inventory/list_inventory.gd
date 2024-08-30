@icon("res://addons/inventoric/sprites/list_inventory_icon.svg")
class_name ICListInventory extends ICInventory

signal item_added(slot: int, item: ICItem)
signal item_removed(slot: int)
signal item_selected(slot: int, item: ICItem)
signal item_moving(slot: int, item: ICItem)

@export var config: ICListInventoryConfig

var _item_collection: ICListCollection:
	set(v):
		_item_collection = v
		initialized.emit(v)
		is_initialized = true

func add_item(slot: int, item: ICItemConfig) -> void:
	assert(_item_collection.get_item(slot) == null, "This item slot not empty.")
	var item_instance = ICItem.new(item)
	_item_collection.set_item(slot, item_instance)
	item_added.emit(slot, item)

func get_item(slot: int) -> ICItem:
	return _item_collection.get_item(slot)

func remove_item(slot: int) -> void:
	_item_collection.set_item(slot, null)
	item_removed.emit(slot)

func swap_items(from: int, to: int) -> void:
	if not config.allow_item_swap:
		return
	
	var from_item = _item_collection.get_item(from)
	var to_item = _item_collection.get_item(to)
	_item_collection.set_element(to, from_item)
	_item_collection.set_element(from, to_item)
	
func get_item_collection() -> ICListCollection:
	return _item_collection

func _ready() -> void:
	assert(config != null, "Inventory config must be set.")
	
	_item_collection = ICListCollection.new(config.size)
