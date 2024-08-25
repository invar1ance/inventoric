extends Node

@export var button: Button
@export var inventory: ICInventory
@export var item: ICItemConfig

func spawn_item() -> void:
	var first_free_slot = inventory.get_first_free_slot_idx()
	inventory.add_item(first_free_slot, ICItem.new(item))

func _ready() -> void:
	button.button_down.connect(spawn_item)
