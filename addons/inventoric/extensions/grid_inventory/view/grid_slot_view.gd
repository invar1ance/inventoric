class_name ICGridSlotView extends "res://addons/inventoric/core/base/slot_view.gd"

const ICSlotView = preload("res://addons/inventoric/core/base/slot_view.gd")

@onready var panel: Panel = $Panel

func init(inventory_view: ICGridInventoryView, inventory_key: Vector2i, item_view: ICGridItemView) -> void:
	super.init(inventory_view, inventory_key, item_view)
	
	panel.add_theme_stylebox_override("panel", get_inventory_view().slot_view_config.default_style)
	
	flow.entered.connect(func(to: ICSlotView.State) -> void:
		match to:
			ICSlotView.State.Default:
				panel.add_theme_stylebox_override("panel", get_inventory_view().slot_view_config.default_style)
				if get_item_view() != null:
					get_item_view().z_index = 0
			ICSlotView.State.Highlight:
				panel.add_theme_stylebox_override("panel", get_inventory_view().slot_view_config.selected_style)
				if get_item_view() != null:
					get_item_view().z_index = 0
			ICSlotView.State.DragFrom:
				panel.add_theme_stylebox_override("panel", get_inventory_view().slot_view_config.drag_from_style)
				if get_item_view() != null:
					get_item_view().z_index = get_inventory_view().config.dragging_item_z_index
			ICSlotView.State.DragTo:
				panel.add_theme_stylebox_override("panel", get_inventory_view().slot_view_config.drag_to_style)
				if get_item_view() != null:
					get_item_view().z_index = 0
	)

func get_inventory_view() -> ICGridInventoryView:
	return super.get_inventory_view()

func get_inventory_key() -> Vector2i:
	return super.get_inventory_key()

func get_item_view() -> ICGridItemView:
	return super.get_item_view()
	
func set_item_view(item_view: ICGridItemView) -> void:
	super.set_item_view(item_view)

func refresh_size() -> void:
	var slot_size: Vector2 = Vector2(
		_inventory_view.slot_view_config.size_h, 
		_inventory_view.slot_view_config.size_v
	)
	
	custom_minimum_size = slot_size
	size = slot_size
	
	refresh_item_view_rect()

func refresh_item_view_rect() -> void:
	if _item_view == null:
		return

	var slot_padding: Vector2 = Vector2(
		_inventory_view.slot_view_config.padding_h,
		_inventory_view.slot_view_config.padding_v
	)
	_item_view.position = Vector2.ZERO
	_item_view.position += slot_padding
	
	var item_size: Vector2 = size - slot_padding * 2
	_item_view.custom_minimum_size = item_size
	_item_view.size = item_size
