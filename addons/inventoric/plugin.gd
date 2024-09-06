@tool
extends EditorPlugin

const ICInventoryView = preload("res://addons/inventoric/core/base/inventory_view.gd")

var _tracked_views: Array[ICInventoryView]

func _enter_tree():
	add_autoload_singleton("Inventoric", "res://addons/inventoric/core/inventory_view_manager.gd")
	_add_default_action()
	
	scene_changed.connect(_on_scene_changed)
	_refresh_tracked_views()

func _exit_tree():
	remove_autoload_singleton("Inventoric")
	_remove_default_action()
	
	scene_changed.disconnect(_on_scene_changed)
	_unload_editor_scripts()

func _add_default_action() -> void:
	if ProjectSettings.has_setting('input/inventoric_select_action'):
		return

	var input_left_click: InputEventMouseButton = InputEventMouseButton.new()
	input_left_click.button_index = MOUSE_BUTTON_LEFT
	input_left_click.pressed = true
	input_left_click.device = -1

	ProjectSettings.set_setting('input/inventoric_select_action', {'deadzone':0.5, 'events':[input_left_click]})
	ProjectSettings.save()

func _remove_default_action() -> void:
	if not ProjectSettings.has_setting('input/inventoric_select_action'):
		return

	ProjectSettings.set_setting('input/inventoric_select_action', null)
	ProjectSettings.save()

func _on_scene_changed(root: Node) -> void:
	_refresh_tracked_views()

func _edit(object: Object) -> void:
	_refresh_tracked_views()

func _handles(object: Object) -> bool:
	return (Engine.is_editor_hint() and 
		object is ICGridInventory or object is ICGridInventoryView or object is ICGridInventoryViewConfig or object is ICGridInventoryConfig or object is ICGridSlotViewConfig or
		object is ICListInventory or object is ICListInventoryView or object is ICListInventoryViewConfig or object is ICListInventoryConfig or object is ICListSlotViewConfig
	)

func _refresh_tracked_views() -> void:
	var current_scene = get_editor_interface().get_edited_scene_root()
	var result_views: Array[Node] = []
	if get_editor_interface() != null and current_scene != null:
		var scene_controls = current_scene.find_children("*", "Control", true)
		for scene_control in scene_controls:
			if scene_control is ICInventoryView:
				result_views.append(scene_control)
	
	_tracked_views.clear()
	for result_view: ICInventoryView in result_views:
		_tracked_views.append(result_view)
				
func _recalculate_inventory_size(view: ICInventoryView) -> void:
	var inventory_size = Vector2.ZERO
	inventory_size = view.calculate_size()
	view.size = inventory_size
	view.custom_minimum_size = inventory_size

func _unload_editor_scripts() -> void:
	_tracked_views.clear()

func _process(delta: float) -> void:
	for tracked_view in _tracked_views:
		_recalculate_inventory_size(tracked_view)
