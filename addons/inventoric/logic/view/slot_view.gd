class_name ICSlotView extends Control

signal slot_item_view_changed(slot_view: ICSlotView)

var config: ICSlotViewConfig
var item_view: ICItemView
var idx: int

func place_item_view(item_view: ICItemView) -> void:
	self.item_view = item_view
	default_highlight()
	if item_view != null:
		if item_view.get_parent() == null:
			add_child(item_view)
		else:
			item_view.reparent(self)
	
	slot_item_view_changed.emit(self)
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

func swap_item_view(with: ICSlotView) -> void:
	var with_item_view: ICItemView
	if with.has_item_view():
		with_item_view = with.item_view
	
	with.place_item_view(item_view)
	place_item_view(with_item_view)

func init(config: ICSlotViewConfig, idx: int) -> void:
	self.config = config
	self.idx = idx
	default_highlight()
