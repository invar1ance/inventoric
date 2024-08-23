class_name ICSlotViewConfig extends Resource

@export_range(0, 1000, 1) var padding_h: float = 8
@export_range(0, 1000, 1) var padding_v: float = 8

@export_group("Styles")
@export var default_style: StyleBox
@export var selected_style: StyleBox
@export var drag_from_style: StyleBox
@export var drag_to_style: StyleBox
