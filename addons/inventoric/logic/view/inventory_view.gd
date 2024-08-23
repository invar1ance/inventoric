class_name ICInventoryView extends Control

signal slot_view_config_changed(config: ICSlotViewConfig)
signal config_changed(config: ICInventoryViewConfig)
signal inventory_changed(inventory: ICInventory)

@export var config: ICInventoryViewConfig:
	set(v):
		config = v
		config_changed.emit(v)
@export var slot_view_config: ICSlotViewConfig:
	set(v):
		slot_view_config = v
		slot_view_config_changed.emit(v)
@export var inventory: ICInventory:
	set(v):
		inventory = v
		inventory_changed.emit(v)

var _inventory_selected: bool = false
var _slot_views: Array[ICSlotView]
var _target_slot: ICSlotView

func get_nearest_slot(position: Vector2, free_only: bool) -> ICSlotView:
	var near_distance = 99999
	var nearest_slot: ICSlotView = null
	
	if free_only:
		for slot in _slot_views:
			var slot_pos = slot.get_global_rect().get_center()
			var distance = slot_pos.distance_squared_to(position)
			if distance < near_distance and slot.is_free():
				near_distance = distance
				nearest_slot = slot
	else:
		for slot in _slot_views:
			var slot_pos = slot.get_global_rect().get_center()
			var distance = slot_pos.distance_squared_to(position)
			if distance < near_distance:
				near_distance = distance
				nearest_slot = slot

	return nearest_slot
	
func generate_item_view(item: ICItem) -> ICItemView:
	var item_view = config.item_scene.instantiate() as ICItemView
	item_view.item = item
	
	return item_view

func generate_slot_view(idx: int) -> ICSlotView:
	var slot_view = config.slot_scene.instantiate() as ICSlotView
	add_child(slot_view)
	_slot_views.append(slot_view)
	slot_view.init(slot_view_config, idx)
	slot_view.slot_item_view_changed.connect(_on_slot_item_view_changed)
	slot_view.global_position = get_slot_view_position(slot_view)
	
	return slot_view
	
func overlap_item_view(item_view: ICItemView) -> bool:
	return get_global_rect().intersects(item_view.get_global_rect())
	
func get_slot_view_position(slot_view: ICSlotView) -> Vector2:
	return Vector2.ONE

func _on_mouse_entered() -> void:
	_inventory_selected = true

func _on_mouse_exited() -> void:
	_inventory_selected = false
		
func _on_slot_item_view_changed(slot_view: ICSlotView) -> void:
	if slot_view.has_item_view():
		inventory.set_item(slot_view.idx, slot_view.item_view.item)
		
func _on_item_changed(idx: int, item: ICItem) -> void:
	var slot_view = _slot_views[idx]
	if slot_view != null:
		slot_view.place_item_view(generate_item_view(item))
	
func _process_target_slot() -> void:
	var dragging_slot_view = InventoryObserver.dragging_slot_view
	
	var nearest_slot: ICSlotView = null
	if dragging_slot_view != null and dragging_slot_view.has_item_view() and overlap_item_view(dragging_slot_view.item_view):
		nearest_slot = get_nearest_slot(dragging_slot_view.item_view.get_global_rect().get_center(), false)
		if nearest_slot != null:
			nearest_slot.drag_to_highlight()
		
	if dragging_slot_view == null and _inventory_selected:
		nearest_slot = get_nearest_slot(get_viewport().get_mouse_position(), false)
		if nearest_slot != null:
			nearest_slot.selected_highlight()
		
	if nearest_slot != _target_slot:
		if _target_slot != null:
			_target_slot.default_highlight()
		_target_slot = nearest_slot
	
func _process_drop() -> void:
	var dragging_slot_view = InventoryObserver.dragging_slot_view
	
	if dragging_slot_view == null or not dragging_slot_view.has_item_view():
		return
	
	if Input.is_action_just_released("inventoric_select_action"):
		if _target_slot != null:
			_target_slot.swap_item_view(dragging_slot_view)
			InventoryObserver.dragging_slot_view = null
		else:
			pass # todo return to parent slot
	
func _process_drag() -> void:
	var dragging_slot_view = InventoryObserver.dragging_slot_view
	
	if _target_slot == null or _target_slot.item_view == null:
		return

	if Input.is_action_just_pressed("inventoric_select_action"):
		_target_slot.item_view.drag_started()
		_target_slot.drag_from_highlight()
		InventoryObserver.dragging_slot_view = _target_slot
	
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)	
	
func _process(delta: float) -> void:
	var dragging_slot_view = InventoryObserver.dragging_slot_view
	
	_process_target_slot()
	_process_drag()
	_process_drop()
