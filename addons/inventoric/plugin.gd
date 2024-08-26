@tool
extends EditorPlugin

var _editor_scripts: Array
var _views: Array

func _enter_tree():
	add_autoload_singleton("Inventoric", "res://addons/inventoric/logic/manager/inventory_view_manager.gd")
	_add_default_action()
	_load_editor_scripts()
	
	scene_changed.connect(_on_scene_changed)
	_refresh_handled_views()
	_apply_editor_scripts()

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
	_refresh_handled_views()

func _edit(object: Object) -> void:
	_refresh_handled_views()

func _handles(object: Object) -> bool:
	return object is ICInventory or object is ICInventoryView or object is ICInventoryViewConfig or object is ICInventoryConfig or object is ICSlotViewConfig

func _apply_editor_scripts() -> void:
	var scene = get_editor_interface().get_edited_scene_root()

	for view in _views:
		for es in _editor_scripts:
			if es is ICInventoryPreviewer and es.handles(view):
				es.redraw(view)
			if es is ICInventoryConfigurator and es.handles(view):
				es.configure(view)
			if es is ICInventoryResizer and es.handles(view):
				es.resize(view)

func _refresh_handled_views() -> void:
	if get_editor_interface() == null or get_editor_interface().get_edited_scene_root() == null:
		_views = []
		return
	
	_views = get_editor_interface().get_edited_scene_root().find_children("*", "ICInventoryView", true)

func _load_editor_scripts() -> void:
	var root = DirAccess.open("res://addons/inventoric/extensions")

	for path in root.get_directories():
		var editor_path = "%s/%s/editor" % [root.get_current_dir(), path]
		var editor_dir = DirAccess.open(editor_path)
		
		for file in editor_dir.get_files():
			var file_path = "%s/%s" % [editor_path, file]
			var script = load(file_path).new()
			
			if script is ICInventoryConfigurator or script is ICInventoryPreviewer or script is ICInventoryResizer:
				_editor_scripts.append(script)

func _unload_editor_scripts() -> void:
	for es in _editor_scripts:
		if es is ICInventoryPreviewer:
			es.clear_canvas_item()
	_editor_scripts.clear()

func _process(delta: float) -> void:
	_apply_editor_scripts()
