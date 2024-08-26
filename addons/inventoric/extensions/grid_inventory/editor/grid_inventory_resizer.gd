extends ICInventoryResizer

static func handles(view: ICInventoryView) -> bool:
	return view is GridInventoryView
	
static func resize(view: ICInventoryView) -> void:
	var container_size = GridLayoutManager.get_container_size(view)
	view.size = container_size
	view.custom_minimum_size = container_size
