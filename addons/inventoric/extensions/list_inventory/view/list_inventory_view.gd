@icon("res://addons/inventoric/sprites/list_inventory_view_icon.svg")
@tool
class_name ICListInventoryView extends "res://addons/inventoric/base/inventory_view.gd"

const AutoloadManager = preload("res://addons/inventoric/core/autoload_manager.gd")

@export var config: ICListInventoryViewConfig:
	set(v):
		config = v
		update_configuration_warnings()
@export var slot_view_config: ICListSlotViewConfig:
	set(v):
		slot_view_config = v
		update_configuration_warnings()
@export var inventory: ICListInventory:
	set(v):
		inventory = v
		update_configuration_warnings()

func is_configured() -> bool:
	return inventory != null and inventory.config != null and slot_view_config != null and config != null
	
func get_inventory() -> ICListInventory:
	return inventory
	
func get_nearest_slot(position: Vector2, free_only: bool) -> ICListSlotView:
	return super.get_nearest_slot(position, free_only)

func add_slot_view(key: int) -> void:
	var slot_view: ICListSlotView = slot_view_config.slot_scene.instantiate()
	add_child(slot_view)
	_slot_views.set_item(key, slot_view)
	slot_view.init(self, key, make_item_view(inventory.get_item(key)))

func make_item_view(item: ICItem) -> ICListItemView:
	if item == null:
		return null
	
	var item_view: ICListItemView = slot_view_config.item_scene.instantiate()
	item_view.init(item.get_config())

	return item_view

func refresh_size() -> void:
	var inventory_size: Vector2 = get_size()
	size = inventory_size
	custom_minimum_size = inventory_size
	
	for idx in inventory.config.size:
		var slot_view = _slot_views.get_item(idx)
		slot_view.refresh_size()
		slot_view.global_position = calculate_slot_position(idx)

func calculate_size() -> Vector2:
	if not is_configured():
		return Vector2.ZERO
	
	var slot_size: Vector2 = Vector2(slot_view_config.size_h, slot_view_config.size_v)
	var inventory_size: int = inventory.config.size
	var spacing: float = config.spacing
	
	return Vector2(slot_size.x, (slot_size.y * inventory_size) + spacing * (inventory_size - 1))
	
func calculate_slot_position(idx: int) -> Vector2:
	if not is_configured():
		return Vector2.ZERO
	
	var start_pos: Vector2 = get_global_rect().position
	return Vector2(start_pos.x, start_pos.y + slot_view_config.size_v * idx)

func _fill_slots() -> void:
	_slot_views = ICListCollection.new(inventory.get_item_collection().size())
	
	for key in inventory.get_item_collection().keys():
		add_slot_view(key)
				
	refresh_size()

func _on_mouse_entered() -> void:
	AutoloadManager.get_view_manager().inventory_selected.emit(self)

func _on_mouse_exited() -> void:
	AutoloadManager.get_view_manager().inventory_deselected.emit(self)
	
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	assert(inventory != null, "Inventory must be set.")
	
	if not inventory.is_node_ready():
		await inventory.ready
	_fill_slots()
#
	inventory.item_added.connect(func(key: int, item: ICItem):
		if AutoloadManager.get_view_manager().is_item_dragging():
			return
		
		var slot_view: ICListSlotView = _slot_views.get_item(key)
		assert(slot_view != null, "SlotView is null on position: %d" % key)

		var item_view: ICListItemView = make_item_view(item)
		slot_view.set_item_view(item_view)
	)
	
	inventory.item_removed.connect(func(key: int):
		if AutoloadManager.get_view_manager().is_item_dragging():
			return
			
		var slot_view: ICListSlotView = _slot_views.get_item(key)
		if slot_view != null:
			slot_view.clear_item_view()
	)
	
	update_configuration_warnings()
	
func _get_configuration_warnings() -> PackedStringArray:
	var errors = []
	if inventory == null:
		errors.append("Inventory requires")
	if config == null:
		errors.append("Config requires")
	if slot_view_config == null:
		errors.append("SlotViewConfig requires")
	
	return errors
