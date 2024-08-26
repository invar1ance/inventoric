@icon("res://addons/inventoric/sprites/grid_inventory_view_icon.png")
class_name GridInventoryView extends ICInventoryView

@export_group("Debug")
@export var debug: bool = true
@export var debug_color_1: Color = Color.GREEN
@export var debug_color_2: Color = Color.LIME_GREEN

func generate_item_view(item: ICItem) -> GridItemView:
	var item_view = config.item_scene.instantiate() as GridItemView
	item_view.ready.connect(func():
		item_view.icon = item.get_config().icon
	)
	
	return item_view

func resize() -> void:
	var container_size = GridLayoutManager.get_container_size(self)
	size = container_size
	custom_minimum_size = container_size
	
	for idx in slot_views.size():
		var slot_view = get_slot_view(idx)
		slot_view.resize(slot_view_config)
		slot_view.global_position = GridLayoutManager.get_slot_position(self, idx)

func generate_slot_view(idx: int) -> ICSlotView:
	var slot_view = super.generate_slot_view(idx)
	slot_view.global_position = GridLayoutManager.get_slot_position(self, idx)
	
	return slot_view
	
func _get_configuration_warnings() -> PackedStringArray:
	var errors = []
	if inventory == null:
		errors.append("Inventory requires")
	if config == null:
		errors.append("Config requires")
	if slot_view_config == null:
		errors.append("SlotViewConfig requires")
	
	return errors

func _notification(what: int) -> void:
	print(what)
