class_name ICInventory extends Node

signal item_changed(idx: int, item: ICItem)

var items: Collection

func append_item(item: ICItem) -> void:
	for idx in items.size():
		if items.get_element(idx) == null:
			items.set_element(idx, item)
			item_changed.emit(idx, item)
			
			break

func get_item(idx: int) -> ICItem:
	return items.get_element(idx)
	
func set_item(idx: int, item: ICItem) -> void:
	var current_item = items.get_element(idx)
	if current_item != null:
		current_item.remove()
	
	items.set_element(idx, item)
	item_changed.emit(idx, item)
	
func has_item(item: ICItem) -> bool:
	return items.has(item)
