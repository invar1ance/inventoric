class_name ICItem extends Object

signal removed

var config: ICItemConfig

func _init(config: ICItemConfig) -> void:
	self.config = config

func remove() -> void:
	removed.emit()
	free()
