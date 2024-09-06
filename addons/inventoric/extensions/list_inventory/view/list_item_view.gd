class_name ICListItemView extends "res://addons/inventoric/core/base/item_view.gd"

var item_icon: Texture2D:
	set(v):
		item_icon = v
		$HBoxContainer/Icon.texture = v
		
var item_name: String:
	set(v):
		item_name = v
		$HBoxContainer/Name.text = v

func init(config: ICItemConfig) -> void:
	super.init(config)
	if not is_node_ready():
		await ready
	
	item_icon = config.icon
	item_name = config.name
