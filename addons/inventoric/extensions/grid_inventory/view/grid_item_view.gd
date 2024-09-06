class_name ICGridItemView extends "res://addons/inventoric/core/base/item_view.gd"

var item_icon: Texture2D:
	set(v):
		item_icon = v
		$Icon.texture = v

func init(config: ICItemConfig) -> void:
	super.init(config)
	if not is_node_ready():
		await ready
		
	item_icon = config.icon
