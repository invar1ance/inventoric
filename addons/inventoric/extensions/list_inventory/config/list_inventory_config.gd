class_name ICListInventoryConfig extends Resource

@export_group("Sizing")
@export_range(1, 1000, 1) var size: int = 10

@export_group("Sorting and Filtering")
@export var continuous_order: bool = true
@export var allow_item_swap: bool = true
@export var drag_and_drop_enabled: bool = true
