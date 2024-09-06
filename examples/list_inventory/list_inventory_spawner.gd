extends Node

@export var button: Button
@export var inventory1: ICListInventory
@export var inventory2: ICListInventory
@export var item: ICItemConfig

func spawn_item() -> void:
	var first_free_slot = inventory1.get_item_collection().get_free_key_front()
	inventory1.add_item(first_free_slot, item)

func _ready() -> void:
	button.button_down.connect(spawn_item)
	inventory1.item_added.connect(func(slot, item): print("Item %s added to inventory 1 slot %s" % [item, slot]))
	inventory1.item_removed.connect(func(slot): print("Item removed from inventory 1 slot %s" % slot))
	inventory1.item_moved.connect(func(from, to, item): print("Item %s moved inside inventory 1 from slot %s to slot %s" % [item, from, to]))
	inventory2.item_added.connect(func(slot, item): print("Item %s added to inventory 2 slot %s" % [item, slot]))
	inventory2.item_removed.connect(func(slot): print("Item removed from inventory 2 slot %s" % slot))
	inventory2.item_moved.connect(func(from, to, item): print("Item %s moved inside inventory 2 from slot %s to slot %s" % [item, from, to]))
