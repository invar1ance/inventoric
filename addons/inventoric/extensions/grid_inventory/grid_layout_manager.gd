class_name GridLayoutManager extends ICLayoutManager

static func editor_render_ready(view: ICInventoryView) -> bool:
	return Engine.is_editor_hint() and view.debug and view.inventory != null and view.inventory.config != null and view.slot_view_config != null and view.config != null

static func get_container_size(view: ICInventoryView) -> Vector2:
	if not editor_render_ready(view):
		return super.get_container_size(view)
	
	var result = Vector2(view.slot_view_config.size_h, view.slot_view_config.size_v)
	var grid_size = Vector2(view.inventory.config.size_h, view.inventory.config.size_v)
	var spacing = Vector2(view.config.spacing_h, view.config.spacing_v)
	if view.inventory != null:
		result = (result * grid_size) + spacing * (grid_size - Vector2.ONE)
		
	return result
	
static func get_slot_position(view: ICInventoryView, slot_view_idx: int) -> Vector2:
	if not editor_render_ready(view):
		return super.get_slot_position(view, slot_view_idx)
		
	var grid_point = GridCoordinator.get_point(view.inventory.config.size_v, slot_view_idx)
	var start_pos = view.get_global_rect().position
	
	return start_pos + Vector2(view.slot_view_config.size_h * grid_point.x, view.slot_view_config.size_v * grid_point.y)
