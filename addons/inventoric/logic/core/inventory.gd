class_name ICInventory extends Node

signal slots_initialized(items: Collection)
signal item_added(idx: int, item: ICItem)
signal item_removed(idx: int)

@export var config: ICInventoryConfig
var is_slots_initialized: bool = false

var slots: Collection:
	set(v):
		slots = v
		slots_initialized.emit(v)
		is_slots_initialized = true

func has_free_slots() -> bool:
	for idx in slots.size():
		if slots.get_element(idx) == null:
			return true
	
	return false

func get_first_free_slot_idx() -> int:
	for idx in slots.size():
		if slots.get_element(idx) == null:
			return idx
		
	return 0
	
func is_slot_free(idx: int) -> bool:
	return slots.get_element(idx) == null
			
func add_item(idx: int, item: ICItem) -> void:
	assert(get_item(idx) == null, "This item slot not empty.")
	slots.set_element(idx, item)
	item_added.emit(idx, item)

func get_item(idx: int) -> ICItem:
	return slots.get_element(idx)
	
func has_item(item: ICItem) -> bool:
	return slots.has(item)

func remove_item(idx: int) -> void:
	slots.set_element(idx, null)
	item_removed.emit(idx)

func swap_items(from_idx: int, to_idx: int) -> void:
	if not config.allow_item_swap:
		return
	
	var from_item = get_item(from_idx)
	var to_item = get_item(to_idx)
	slots.set_element(to_idx, from_item)
	slots.set_element(from_idx, to_item)
	
func _ready() -> void:
	assert(config != null, "Inventory config must be set.")
