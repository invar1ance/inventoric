@icon("res://addons/inventoric/sprites/grid_inventory_view_icon.svg")
@tool
class_name ICGridInventoryView extends "res://addons/inventoric/base/inventory_view.gd"

const AutoloadManager = preload("res://addons/inventoric/core/autoload_manager.gd")

@export var config: ICGridInventoryViewConfig:
	set(v):
		config = v
		update_configuration_warnings()
@export var slot_view_config: ICGridSlotViewConfig:
	set(v):
		slot_view_config = v
		update_configuration_warnings()
@export var inventory: ICGridInventory:
	set(v):
		inventory = v
		update_configuration_warnings()

func is_configured() -> bool:
	return inventory != null and inventory.config != null and slot_view_config != null and config != null
	
func get_inventory() -> ICGridInventory:
	return inventory
	
func get_nearest_slot(position: Vector2, free_only: bool) -> ICGridSlotView:
	return super.get_nearest_slot(position, free_only)

func add_slot_view(key: Vector2i) -> void:
	var slot_view: ICGridSlotView = slot_view_config.slot_scene.instantiate()
	add_child(slot_view)
	_slot_views.set_item(key, slot_view)
	slot_view.init(self, key, make_item_view(inventory.get_item(key)))

func make_item_view(item: ICItem) -> ICGridItemView:
	if item == null:
		return null
	
	var item_view: ICGridItemView = slot_view_config.item_scene.instantiate()
	item_view.init(item.get_config())

	return item_view

func refresh_size() -> void:
	var inventory_size: Vector2 = get_size()
	size = inventory_size
	custom_minimum_size = inventory_size
	
	for x in inventory.config.size_h:
		for y in inventory.config.size_v:
			var grid_pos: Vector2i = Vector2i(x, y)
			var slot_view = _slot_views.get_item(grid_pos)
			slot_view.refresh_size()
			slot_view.global_position = calculate_slot_position(grid_pos)
	
func calculate_size() -> Vector2:
	if not is_configured():
		return Vector2.ZERO
	
	var slot_size: Vector2 = Vector2(slot_view_config.size_h, slot_view_config.size_v)
	var grid_size: Vector2 = Vector2(inventory.config.size_h, inventory.config.size_v)
	var spacing: Vector2 = Vector2(config.spacing_h, config.spacing_v)
	
	return (slot_size * grid_size) + spacing * (grid_size - Vector2.ONE)
	
func calculate_slot_position(inventory_key: Vector2i) -> Vector2:
	if not is_configured():
		return Vector2.ZERO
	
	var start_pos = get_global_rect().position
	return start_pos + Vector2(slot_view_config.size_h * inventory_key.x, slot_view_config.size_v * inventory_key.y)
	
func _fill_slots() -> void:
	_slot_views = ICGridCollection.new(inventory.get_item_collection().size())
	
	for key in inventory.get_item_collection().keys():
		add_slot_view(key)
				
	refresh_size()

func _on_mouse_entered() -> void:
	AutoloadManager.get_view_manager().inventory_selected.emit(self)

func _on_mouse_exited() -> void:
	AutoloadManager.get_view_manager().inventory_deselected.emit(self)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	assert(inventory != null, "Inventory must be set.")
	
	if not inventory.is_node_ready():
		await inventory.ready
	
	_fill_slots()

	inventory.item_added.connect(func(key: Vector2i, item: ICItem):
		if AutoloadManager.get_view_manager().is_item_dragging():
			return
		
		var slot_view: ICGridSlotView = _slot_views.get_item(key)
		assert(slot_view != null, "SlotView is null on position: %d,%d" % [key.x, key.y])

		var item_view: ICGridItemView = make_item_view(item)
		slot_view.set_item_view(item_view)
	)
	
	inventory.item_removed.connect(func(key: Vector2i):
		if AutoloadManager.get_view_manager().is_item_dragging():
			return
			
		var slot_view: ICGridSlotView = _slot_views.get_item(key)
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
