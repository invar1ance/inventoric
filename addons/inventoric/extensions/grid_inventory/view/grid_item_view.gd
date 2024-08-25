class_name GridItemView extends ICItemView

@onready var icon_sprite: TextureRect = $Icon

var icon: Texture2D:
	set(v):
		icon = v
		icon_sprite.texture = v
