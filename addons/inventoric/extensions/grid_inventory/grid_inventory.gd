class_name GridInventory extends ICInventory

@export_range(1, 100, 1) var grid_size_h: int = 5
@export_range(1, 100, 1) var grid_size_v: int = 5
@export var strict_order: bool = true
	
func _ready() -> void:
	items = Collection.new(grid_size_h * grid_size_v)
