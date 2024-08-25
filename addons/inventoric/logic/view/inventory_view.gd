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

var slot_views: Collection

func get_nearest_slot(position: Vector2, free_only: bool) -> ICSlotView:
	var near_distance = 99999
	var nearest_slot: ICSlotView = null
	
	for slot in slot_views.all():
		var slot_pos = slot.get_global_rect().get_center()
		var distance = slot_pos.distance_squared_to(position)
		
		if distance < near_distance and (not free_only or not slot.has_item_view()):
			near_distance = distance
			nearest_slot = slot

	return nearest_slot
	
func get_container_size() -> Vector2:
	return Vector2.ZERO
	
func get_slot_view_position(slot_view_idx: int) -> Vector2:
	return Vector2.ZERO
	 
func resize() -> void:
	pass
	
func generate_item_view(item: ICItem) -> ICItemView:
	var item_view = config.item_scene.instantiate() as ICItemView
	
	return item_view

func generate_slot_view(idx: int) -> ICSlotView:
	var slot_view = config.slot_scene.instantiate() as ICSlotView
	add_child(slot_view)
	slot_views.set_element(idx, slot_view)
	slot_view.init(self, idx, slot_view_config)
	slot_view.global_position = get_slot_view_position(idx)
	
	return slot_view
	
func overlap_item_view(item_view: ICItemView) -> bool:
	if item_view == null:
		return false
	
	return get_global_rect().intersects(item_view.get_global_rect())
	
func get_slot_view(idx: int) -> ICSlotView:
	return slot_views.get_element(idx)
	
func _on_mouse_entered() -> void:
	InventoryViewManager.inventory_selected.emit(self)

func _on_mouse_exited() -> void:
	InventoryViewManager.inventory_deselected.emit(self)
	
func generate_inventory_view(slots: Collection) -> void:
	update_configuration_warnings()
	slot_views = Collection.new(slots.size())
	if slots != null:
		for idx in slots.size():
			var item = slots.get_element(idx)
			var slot_view = generate_slot_view(idx)
			if item != null: 
				var item_view = generate_item_view(item)
				slot_view.set_item_view(item_view)
		resize()
	
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	assert(inventory != null, "Inventory must be set.")
	
	if inventory.is_slots_initialized:
		generate_inventory_view(inventory.slots)
	else:
		inventory.slots_initialized.connect(generate_inventory_view)
#
	inventory.item_added.connect(func(idx: int, item: ICItem):
		if InventoryViewManager.is_item_dragging():
			return
		
		var slot_view: ICSlotView = slot_views.get_element(idx)
		assert(slot_view != null, "SlotView is null on index %d" % idx)

		var item_view = generate_item_view(item)
		slot_view.set_item_view(item_view)
	)
	inventory.item_removed.connect(func(idx: int):
		if InventoryViewManager.is_item_dragging():
			return
			
		var slot_view = slot_views.get_element(idx)
#
		if slot_view != null:
			slot_view.clear_item_view()
	)
