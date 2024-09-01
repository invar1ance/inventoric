class_name ICInventory extends Node

## This class represents an inventory system, managing a collection of items within slots.

signal inventory_filled ## Emitted when the inventory becomes full.

## Adds an [param item] to the specified [param slot] in the inventory.
func add_item(slot, item: ICItemConfig) -> void:
	pass

## Retrieves the item from the specified [param slot] in the inventory.
func get_item(slot) -> ICItem:
	return null

## Removes the item from the specified [param slot] in the inventory.
func remove_item(slot) -> void:
	pass

## Swaps the [param from] and [param to] items between two specified slots in the inventory.
func swap_items(from, to) -> void:
	pass

## Retrieves the item collection associated with the inventory. [br]
## [u]Modify the collection manually at your own risk! It is recommended to use the collection only for data retrieval.[/u]
func get_item_collection() -> ICBaseCollection:
	return null
