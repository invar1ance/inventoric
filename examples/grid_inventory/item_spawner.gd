extends Node

@export var button: Button
@export var inventory: ICGridInventory
@export var item: ICItemConfig

func spawn_item() -> void:
	var first_free_slot = inventory.get_item_collection().get_free_key_front()
	inventory.add_item(first_free_slot, item)

func _ready() -> void:
	button.button_down.connect(spawn_item)
