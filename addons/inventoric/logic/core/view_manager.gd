class_name SlotViewManager extends RefCounted

static func get_slot_view_position(idx: int) -> Vector2:
	return Vector2.ONE
	
static func generate_item_view(view: PackedScene, item: ICItem) -> ICItemView:
	var item_view = view.instantiate() as ICItemView
	item_view.item = item
	
	return item_view

static func generate_slot_view(view: PackedScene, idx: int, item_view: ICItemView, padding: Vector2) -> ICSlotView:
	var slot_view = view.instantiate() as ICSlotView
	slot_view.init(item_view, padding, idx)
	_slot_views.append(slot_view)
	slot_view.slot_item_view_changed.connect(_on_slot_item_view_changed)
	slot_view.global_position = _get_slot_view_position(inventory.items.get_coord(idx))
	
	return slot_view
