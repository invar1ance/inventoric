class_name ICItem

var _config: ICItemConfig

func _init(config: ICItemConfig) -> void:
	_config = config

func get_config() -> ICItemConfig:
	return _config
