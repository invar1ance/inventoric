class_name ICItemView extends Control

var item: ICItem
var drag_offset_position: Vector2

func drag_started() -> void:
	drag_offset_position = get_local_mouse_position()
	z_index = 20
	
func resize(size: Vector2i) -> void:
	self.size = size
	custom_minimum_size = size

func _ready() -> void:
	item.removed.connect(queue_free)
