@tool
class_name GridInventoryView extends ICInventoryView

@export_group("Debug")
@export var debug: bool = true
@export var debug_color_1: Color = Color.GREEN
@export var debug_color_2: Color = Color.LIME_GREEN

func get_container_size() -> Vector2:
	var result = Vector2(slot_view_config.size_h, slot_view_config.size_v)
	var grid_size = Vector2(inventory.grid_size_h, inventory.grid_size_v)
	var spacing = Vector2(config.spacing_h, config.spacing_v)
	if inventory != null:
		result = (result * grid_size) + spacing * (grid_size - Vector2.ONE)
		
	return result
	
func get_slot_view_position(slot_view: ICSlotView) -> Vector2:
	var grid_point = GridPositionHelper.get_point(inventory.grid_size_v, slot_view.idx)
	var start_pos = get_global_rect().position
	
	return start_pos + Vector2(slot_view_config.size_h * grid_point.x, slot_view_config.size_v * grid_point.y)
	
func fill_slots(items: Collection) -> void:
	for idx in items.size():
		var item = items.get_element(idx)
		var slot_view = generate_slot_view(idx)
		if item != null: 
			var item_view = generate_item_view(item)
			slot_view.place_item_view(item_view)
	 
func resize() -> void:
	var container_size = get_container_size()
	size = container_size
	custom_minimum_size = container_size
	
	for idx in _slot_views.size():
		var slot_view = _slot_views[idx]
		slot_view.resize(slot_view_config)
		slot_view.global_position = get_slot_view_position(slot_view)

func _on_inventory_changed(i: ICInventory) -> void:
	update_configuration_warnings()
	if i == null:
		_slot_views.clear()
		resize()
		return
		
	if i.items:
		fill_slots(i.items)
		resize()
	else:
		i.items_changed.connect(func(i: Collection):
			fill_slots(i.items)
			resize()
		)
	
func _ready() -> void:
	super._ready()
	
#region Editor presets
	if Engine.is_editor_hint():
		config_changed.connect(func(config: ICInventoryViewConfig):
			update_configuration_warnings()
			if config.item_scene == null:
				config.item_scene = load("res://addons/inventoric/extensions/grid_inventory/scenes/grid_item.tscn")
			if config.slot_scene == null:
				config.slot_scene = load("res://addons/inventoric/extensions/grid_inventory/scenes/grid_slot.tscn")
		)
		
		slot_view_config_changed.connect(func(config: ICSlotViewConfig):
			update_configuration_warnings()
			if config.default_style == null:
				config.default_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_default_style.tres")
			if config.selected_style == null:
				config.selected_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_selected_style.tres")
			if config.drag_from_style == null:
				config.drag_from_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_drag_from_style.tres")
			if config.drag_to_style == null:
				config.drag_to_style = load("res://addons/inventoric/extensions/grid_inventory/style/slot_drag_to_style.tres")
		)
#endregion
	else:
		inventory_changed.connect(_on_inventory_changed)
		_on_inventory_changed(inventory)

#region Debug
func _draw():
	if not Engine.is_editor_hint() or not debug or inventory == null or slot_view_config == null or config == null:
		return
		
	var rect = get_global_rect()
	var tl = Vector2.ZERO
	var br = tl + get_container_size()
	var bl = Vector2(tl.x, br.y)
	var tr = Vector2(br.x, tl.y)
	
	draw_line(tr, br, debug_color_1, 1.5)
	draw_line(tl, bl, debug_color_1, 1.5)
	draw_line(tl, tr, debug_color_1, 1.5)
	draw_line(bl, br, debug_color_1, 1.5)
	
	var calculated_x = tl.x + slot_view_config.size_h + config.spacing_h * 0.5
	for x in range(1, inventory.grid_size_h):
		var from = Vector2(calculated_x, tl.y)
		var to = Vector2(calculated_x, br.y)
		draw_line(from, to, debug_color_1, 1.5)
		calculated_x += slot_view_config.size_h + config.spacing_h
	
	var calculated_y = tl.y + slot_view_config.size_v + config.spacing_v * 0.5
	for y in range(1, inventory.grid_size_v):
		var from = Vector2(tl.x, calculated_y)
		var to = Vector2(tr.x, calculated_y)
		draw_line(from, to, debug_color_1, 1.5)
		calculated_y += slot_view_config.size_v + config.spacing_v
	
	var slot_size = Vector2(slot_view_config.size_h, slot_view_config.size_v)
	var slot_padding = Vector2(slot_view_config.padding_h, slot_view_config.padding_v)
	var item_size = Vector2(slot_view_config.size_h, slot_view_config.size_v) - Vector2(slot_view_config.padding_h, slot_view_config.padding_v) * 2
	var spacing_offset = Vector2.ZERO
	for item_x in inventory.grid_size_h:
		for item_y in inventory.grid_size_v:
			var item_pos = tl + Vector2(item_x, item_y) * slot_size + slot_padding + spacing_offset
			var item_rect = Rect2(item_pos, item_size)
			draw_rect(item_rect, debug_color_2)
			spacing_offset.y += config.spacing_v
		spacing_offset.y = 0
		spacing_offset.x += config.spacing_h

func _process(delta: float) -> void:
	super._process(delta)
	queue_redraw()

func _get_configuration_warnings() -> PackedStringArray:
	var errors = []
	if inventory == null:
		errors.append("Inventory requires")
	if config == null:
		errors.append("Config requires")
	if slot_view_config == null:
		errors.append("SlotViewConfig requires")
	
	return errors
#endregion
