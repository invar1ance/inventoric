class_name ICInventoryView extends Control

var _slot_views: ICBaseCollection

func is_configured() -> bool:
	return false
	
func get_inventory() -> ICInventory:
	return null
	
func get_nearest_slot(position: Vector2, free_only: bool) -> ICSlotView:
	var near_distance: float = 99999
	var nearest_slot: ICSlotView = null
	
	for slot: ICSlotView in _slot_views:
		var slot_pos: Vector2 = slot.get_global_rect().get_center()
		var distance: float = slot_pos.distance_squared_to(position)
		
		if distance < near_distance and (not free_only or slot.get_item_view() == null):
			near_distance = distance
			nearest_slot = slot

	return nearest_slot
	
func add_slot_view(key) -> void:
	pass

func make_item_view(item: ICItem) -> ICItemView:
	return null

func overlap_rect(rect: Rect2) -> bool:
	return get_global_rect().intersects(rect)

func refresh_size() -> void:
	pass
	
func calculate_size() -> Vector2:
	return Vector2.ZERO
