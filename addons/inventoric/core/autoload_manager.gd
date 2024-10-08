const InventoryViewManager = preload("res://addons/inventoric/core/inventory_view_manager.gd")

static func get_view_manager() -> InventoryViewManager:
	if Engine.is_editor_hint():
		return null
	if not Engine.get_main_loop().root.has_node("Inventoric"):
		return null
	return Engine.get_main_loop().root.get_node("Inventoric")
