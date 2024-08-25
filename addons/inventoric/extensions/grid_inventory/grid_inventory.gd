@icon("res://addons/inventoric/sprites/grid_inventory_icon.png")
class_name GridInventory extends ICInventory
	
func _ready() -> void:
	super._ready()
	assert(config is GridInventoryConfig, "Inventory config must be GridInventoryConfig.")
	
	slots = Collection.new(config.size_h * config.size_v)
