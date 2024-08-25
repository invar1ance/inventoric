class_name ICSlotView extends Control

var config: ICSlotViewConfig
var inventory_view: ICInventoryView
var idx: int
var item_view: ICItemView

func set_item_view(new_item_view: ICItemView) -> void:
	item_view = new_item_view
	default_highlight()

	if new_item_view != null:
		if new_item_view.get_parent() == null:
			add_child(item_view)
		else:
			new_item_view.reparent(self)
	
	item_view_reset_position()
	item_view_reset_size()

func default_highlight() -> void:
	pass
	
func selected_highlight() -> void:
	pass
	
func drag_from_highlight() -> void:
	pass
	
func drag_to_highlight() -> void:
	pass

func has_item_view() -> bool:
	return item_view != null
	
func match_item_view(item_view: ICItemView) -> bool:
	return self.item_view == item_view

func resize(config: ICSlotViewConfig) -> void:
	self.config = config
	
	custom_minimum_size = Vector2(config.size_h, config.size_v)
	size = custom_minimum_size
	
	item_view_reset_size()
	item_view_reset_position()

func item_view_reset_position() -> void:
	if item_view == null:
		return
		
	item_view.position = Vector2.ZERO
	item_view.position += Vector2(config.padding_h, config.padding_v)
		
func item_view_reset_size() -> void:
	if item_view == null:
		return
	
	var item_size = size - Vector2(config.padding_h, config.padding_v) * 2
	item_view.resize(item_size)
	
func clear_item_view() -> void:
	if item_view != null:
		item_view.queue_free()

func init(inventory_view: ICInventoryView, idx: int, config: ICSlotViewConfig) -> void:
	self.inventory_view = inventory_view
	self.idx = idx
	self.config = config
	default_highlight()
