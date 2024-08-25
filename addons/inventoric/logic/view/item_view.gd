class_name ICItemView extends Control
	
func resize(size: Vector2i) -> void:
	self.size = size
	custom_minimum_size = size
