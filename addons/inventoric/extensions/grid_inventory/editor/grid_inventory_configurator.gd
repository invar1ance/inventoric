extends ICInventoryConfigurator

static func handles(object: Object) -> bool:
	return object is GridInventoryView and Engine.is_editor_hint()

static func configure(view: ICInventoryView) -> void:
	var view_config = view.config as GridInventoryViewConfig
	if view_config != null:
		if view_config.item_scene == null:
			view_config.item_scene = load("res://addons/inventoric/extensions/grid_inventory/scenes/grid_item.tscn")
		if view_config.slot_scene == null:
			view_config.slot_scene = load("res://addons/inventoric/extensions/grid_inventory/scenes/grid_slot.tscn")
	
	var slot_view_config = view.slot_view_config as ICSlotViewConfig
	if slot_view_config != null:
		if slot_view_config.default_style == null:
			slot_view_config.default_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_default_style.tres")
		if slot_view_config.selected_style == null:
			slot_view_config.selected_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_selected_style.tres")
		if slot_view_config.drag_from_style == null:
			slot_view_config.drag_from_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_drag_from_style.tres")
		if slot_view_config.drag_to_style == null:
			slot_view_config.drag_to_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_drag_to_style.tres")

	view.update_configuration_warnings()
