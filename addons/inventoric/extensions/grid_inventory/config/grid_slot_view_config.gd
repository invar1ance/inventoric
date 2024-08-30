class_name ICGridSlotViewConfig extends Resource

@export_group("Configuration")
@export var slot_scene: PackedScene = preload("res://addons/inventoric/extensions/grid_inventory/scene/grid_slot.tscn")
@export var item_scene: PackedScene = preload("res://addons/inventoric/extensions/grid_inventory/scene/grid_item.tscn")

@export_group("Sizing")
@export_range(1, 1000, 1) var size_h: float = 64
@export_range(1, 1000, 1) var size_v: float = 64
@export_range(0, 1000, 1) var padding_h: float = 8
@export_range(0, 1000, 1) var padding_v: float = 8

@export_group("Styles")
@export var default_style: StyleBox = preload("res://addons/inventoric/extensions/grid_inventory/style/slot_default_style.tres")
@export var selected_style: StyleBox = preload("res://addons/inventoric/extensions/grid_inventory/style/slot_selected_style.tres")
@export var drag_from_style: StyleBox = preload("res://addons/inventoric/extensions/grid_inventory/style/slot_drag_from_style.tres")
@export var drag_to_style: StyleBox = preload("res://addons/inventoric/extensions/grid_inventory/style/slot_drag_to_style.tres")
