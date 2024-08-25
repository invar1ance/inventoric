@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("InventoryViewManager", "res://addons/inventoric/logic/inventory_view_manager.gd")
	_add_default_action()
	

func _exit_tree():
	remove_autoload_singleton("InventoryViewManager")
	_remove_default_action()

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
