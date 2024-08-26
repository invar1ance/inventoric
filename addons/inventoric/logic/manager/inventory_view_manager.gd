class_name InventoryViewManager extends Node

const NULL_IDX: int = -1

signal inventory_selected(view: ICInventoryView)
signal inventory_deselected(view: ICInventoryView)
signal item_drag(from: ICSlotView)
signal item_drop(from: ICSlotView, to: ICSlotView)

var selected_inventory_views: Array[ICInventoryView] = []
var drag_from_slot: ICSlotView
var target_slot: ICSlotView
var drag_offset_position: Vector2

func is_item_dragging() -> bool:
	return drag_from_slot != null

func _process_slot_targeting() -> void:
	if selected_inventory_views.is_empty():
		if target_slot != null:
			target_slot.default_highlight()
			target_slot = null
		return
	
	var selected_view: ICInventoryView = selected_inventory_views.back()
	var nearest_slot: ICSlotView = null
	var dragging_item: ICItemView = drag_from_slot.item_view if drag_from_slot != null else null
	
	if dragging_item != null and selected_view.overlap_item_view(dragging_item):
		nearest_slot = selected_view.get_nearest_slot(dragging_item.get_global_rect().get_center(), false)
		if nearest_slot != null:
			nearest_slot.drag_to_highlight()
		
	if dragging_item == null:
		nearest_slot = selected_view.get_nearest_slot(get_viewport().get_mouse_position(), false)
		if nearest_slot != null:
			nearest_slot.selected_highlight()
	
	if nearest_slot != target_slot:
		if target_slot != null:
			target_slot.default_highlight()
		target_slot = nearest_slot
	
func _process_drag() -> void:
	if drag_from_slot != null or target_slot == null or not target_slot.has_item_view():
		return

	if Input.is_action_just_pressed("inventoric_select_action"):
		var selected_view: ICInventoryView = selected_inventory_views.back()
		drag_from_slot = target_slot
		drag_offset_position = drag_from_slot.item_view.get_local_mouse_position()
		drag_from_slot.item_view.z_index = selected_view.config.dragging_item_z_index
		
		drag_from_slot.drag_from_highlight()
		item_drag.emit(selected_view, drag_from_slot.idx)

func _process_drop() -> void:
	if drag_from_slot == null:
		return

	if Input.is_action_just_released("inventoric_select_action"):
		if (target_slot == null or target_slot == drag_from_slot 
		or (target_slot.inventory_view.inventory.is_slot_free(target_slot.idx) 
			and not target_slot.inventory_view.inventory.config.allow_item_swap)
		):
			drag_from_slot.item_view_reset_position()
			drag_from_slot.item_view.z_index = 0
			drag_offset_position = Vector2.ZERO
			drag_from_slot = null
			return

		target_slot.set_item_view(drag_from_slot.item_view)
		item_drop.emit(
			drag_from_slot, 
			target_slot
		)
		
		var drag_from_item = drag_from_slot.inventory_view.inventory.get_item(drag_from_slot.idx)
		var drag_to_item = target_slot.inventory_view.inventory.get_item(target_slot.idx)
		drag_from_slot.inventory_view.inventory.remove_item(drag_from_slot.idx)
		drag_from_slot.inventory_view.inventory.add_item(drag_from_slot.idx, drag_to_item)
		target_slot.inventory_view.inventory.remove_item(target_slot.idx)
		target_slot.inventory_view.inventory.add_item(target_slot.idx, drag_from_item)
		
		drag_from_slot = null
	
func _ready() -> void:
	inventory_selected.connect(func(view: ICInventoryView):
		if selected_inventory_views.has(view):
			return
			
		selected_inventory_views.append(view)
	)
	
	inventory_deselected.connect(func(view: ICInventoryView):
		var idx = selected_inventory_views.find(view)
		if idx == NULL_IDX:
			return
		
		selected_inventory_views.remove_at(idx)
	)

func _process(delta: float) -> void:
	_process_slot_targeting()
	_process_drag()
	_process_drop()
	
	if is_item_dragging() and drag_from_slot != null and drag_from_slot.has_item_view():
		var mouse_position = get_viewport().get_mouse_position()
		drag_from_slot.item_view.global_position = mouse_position - drag_offset_position
