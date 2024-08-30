class_name ICGridItemView extends ICItemView

@onready var icon_sprite: TextureRect = $Icon

var icon: Texture2D:
	set(v):
		icon = v
		icon_sprite.texture = v

func init(config: ICItemConfig) -> void:
	super.init(config)
	
	if not is_node_ready():
		await ready
	icon = config.icon
