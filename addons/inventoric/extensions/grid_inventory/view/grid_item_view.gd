class_name GridItemView extends ICItemView

@export var icon: Texture2D

func _process(delta: float) -> void:
	var dragging_slot = InventoryObserver.dragging_slot_view
	
	if dragging_slot != null and dragging_slot.match_item_view(self):
		var mouse_position = get_viewport().get_mouse_position()
		global_position = mouse_position - drag_offset_position
