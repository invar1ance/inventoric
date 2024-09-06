extends Node

const ICInventory = preload("res://addons/inventoric/core/base/inventory.gd")
const ICInventoryView = preload("res://addons/inventoric/core/base/inventory_view.gd")
const ICSlotView = preload("res://addons/inventoric/core/base/slot_view.gd")
const ICItemView = preload("res://addons/inventoric/core/base/item_view.gd")

const NULL_IDX: int = -1

signal inventory_selected(inventory_view: ICInventoryView)
signal inventory_deselected(inventory_view: ICInventoryView)
signal item_drag(from: ICSlotView)
signal item_drop(from: ICSlotView, to: ICSlotView)

var selected_inventory_views: Array[ICInventoryView] = []
var drag_from_slot: ICSlotView
var highlight_slot: ICSlotView
var drag_offset_position: Vector2

func is_item_dragging() -> bool:
	return drag_from_slot != null

func _process_slot_targeting() -> void:
	if selected_inventory_views.is_empty():
		if highlight_slot != null and not highlight_slot.flow.has(ICSlotView.State.DragFrom):
			highlight_slot.flow.apply(ICSlotView.State.Default)
			highlight_slot = null
		return
	
	var selected_inventory: ICInventoryView = selected_inventory_views.back()
	var nearest_slot: ICSlotView = null
		
	var dragging_item: ICItemView = drag_from_slot.get_item_view() if drag_from_slot != null else null
	# items are not dragging
	if dragging_item == null:
		nearest_slot = selected_inventory.get_nearest_slot(get_viewport().get_mouse_position(), false)
		if nearest_slot != null:
			nearest_slot.flow.apply(ICSlotView.State.Highlight)
	else:
		if selected_inventory.overlap_rect(dragging_item.get_global_rect()):
			nearest_slot = selected_inventory.get_nearest_slot(dragging_item.get_global_rect().get_center(), false)
			if nearest_slot != null:
				if nearest_slot != drag_from_slot:
					nearest_slot.flow.apply(ICSlotView.State.DragTo)
	
	# update highlight slot
	if nearest_slot != highlight_slot:
		if highlight_slot != null and not highlight_slot.flow.has(ICSlotView.State.DragFrom):
			highlight_slot.flow.apply(ICSlotView.State.Default)
	highlight_slot = nearest_slot
	
func _process_drag() -> void:
	if drag_from_slot != null or highlight_slot == null or highlight_slot.get_item_view() == null:
		return

	if Input.is_action_just_pressed("inventoric_select_action"):
		var selected_inventory: ICInventoryView = selected_inventory_views.back()
		drag_from_slot = highlight_slot
		highlight_slot = null
		drag_offset_position = drag_from_slot.get_item_view().get_local_mouse_position()
		
		drag_from_slot.flow.apply(ICSlotView.State.DragFrom)
		item_drag.emit(drag_from_slot)

func _process_drop() -> void:
	if drag_from_slot == null:
		return

	if Input.is_action_just_released("inventoric_select_action"):
		if (highlight_slot == null or highlight_slot == drag_from_slot 
			or (highlight_slot.get_inventory_view().get_inventory().get_item(highlight_slot.get_inventory_key()) 
				and not highlight_slot.get_inventory_view().get_inventory().config.allow_item_swap)
		):
			drag_from_slot.refresh_item_view_rect()
			drag_offset_position = Vector2.ZERO
		else:
			highlight_slot.set_item_view(drag_from_slot.get_item_view())
			item_drop.emit(
				drag_from_slot, 
				highlight_slot
			)
			
			
			## todo convertation from one inventory type to another
			var drag_from_item: ICItem = drag_from_slot.get_inventory_view().get_inventory().get_item(drag_from_slot.get_inventory_key())
			var drag_from_item_config: ICItemConfig = drag_from_item.get_config() if drag_from_item != null else null
			var drag_from_inventory: ICInventory = drag_from_slot.get_inventory_view().get_inventory()
			var drag_to_item: ICItem = highlight_slot.get_inventory_view().get_inventory().get_item(highlight_slot.get_inventory_key())
			var drag_to_item_config = drag_to_item.get_config() if drag_to_item != null else null
			var drag_to_inventory: ICInventory = highlight_slot.get_inventory_view().get_inventory()
			
			if drag_from_inventory == drag_to_inventory:
				drag_from_inventory.swap_items(drag_from_slot.get_inventory_key(), highlight_slot.get_inventory_key())
			else:
				drag_from_slot.get_inventory_view().get_inventory().remove_item(drag_from_slot.get_inventory_key())
				drag_from_slot.get_inventory_view().get_inventory().add_item(drag_from_slot.get_inventory_key(), drag_from_item_config)
				highlight_slot.get_inventory_view().get_inventory().remove_item(highlight_slot.get_inventory_key())
				highlight_slot.get_inventory_view().get_inventory().add_item(highlight_slot.get_inventory_key(), drag_from_item_config)
			
			highlight_slot.flow.apply(ICSlotView.State.Default)
			highlight_slot = null
		
		drag_from_slot.flow.apply(ICSlotView.State.Default)
		drag_from_slot = null
	
func _ready() -> void:
	inventory_selected.connect(func(inventory_view: ICInventoryView) -> void:
		if selected_inventory_views.has(inventory_view):
			return
			
		selected_inventory_views.append(inventory_view)
	)
	
	inventory_deselected.connect(func(inventory_view: ICInventoryView) -> void:
		var idx: int = selected_inventory_views.find(inventory_view)
		if idx == NULL_IDX:
			return
		
		selected_inventory_views.remove_at(idx)
	)

func _process(delta: float) -> void:
	_process_slot_targeting()
	_process_drag()
	_process_drop()
	
	if is_item_dragging() and drag_from_slot != null and drag_from_slot.get_item_view() != null:
		var mouse_position = get_viewport().get_mouse_position()
		drag_from_slot.get_item_view().global_position = mouse_position - drag_offset_position
