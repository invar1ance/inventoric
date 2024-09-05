extends Control

const ICInventoryView = preload("res://addons/inventoric/base/inventory_view.gd")
const ICItemView = preload("res://addons/inventoric/base/item_view.gd")

enum State {
	Default,
	Highlight,
	DragFrom,
	DragTo,
	DragToInvalid
}

var flow: Flow
var _inventory_view: ICInventoryView
var _inventory_key: Variant
var _item_view: ICItemView

func init(inventory_view, inventory_key, item_view) -> void:
	self._inventory_view = inventory_view
	self._inventory_key = inventory_key
	set_item_view(item_view)
	
	flow = Flow.new(State.Default)
	flow.add_transition(State.Default, State.Highlight)
	flow.add_transition(State.Default, State.DragTo)
	flow.add_transition(State.Default, State.DragToInvalid)
	flow.add_transition(State.Default, State.DragFrom)
	flow.add_transition(State.Highlight, State.DragFrom)
	flow.add_transition(State.Highlight, State.Default)
	flow.add_transition(State.DragFrom, State.Default)
	flow.add_transition(State.DragTo, State.Default)
	
func set_item_view(item_view) -> void:
	_item_view = item_view

	if item_view != null:
		if item_view.get_parent() == null:
			add_child(item_view)
		else:
			item_view.reparent(self)
	
	refresh_size()

func get_inventory_view() -> ICInventoryView:
	return _inventory_view

func get_inventory_key() -> Variant:
	return _inventory_key

func get_item_view() -> ICItemView:
	return _item_view
	
func refresh_size() -> void:
	pass
	
func refresh_item_view_rect() -> void:
	pass
	
func clear_item_view() -> void:
	if _item_view != null:
		_item_view.queue_free()
