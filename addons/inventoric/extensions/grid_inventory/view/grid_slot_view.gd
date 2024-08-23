class_name GridSlotView extends ICSlotView

@onready var panel: Panel = $Panel

func default_highlight() -> void:
	panel.add_theme_stylebox_override("panel", config.default_style)
	
func selected_highlight() -> void:
	panel.add_theme_stylebox_override("panel", config.selected_style)
	
func drag_from_highlight() -> void:
	panel.add_theme_stylebox_override("panel", config.drag_from_style)
	
func drag_to_highlight() -> void:
	panel.add_theme_stylebox_override("panel", config.drag_to_style)
