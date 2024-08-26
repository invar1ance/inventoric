extends ICInventoryResizer

func handles(view: ICInventoryView) -> bool:
	return view is GridInventoryView
	
func resize(view: ICInventoryView) -> void:
	var container_size = GridLayoutManager.get_container_size(view)
	view.size = container_size
	view.custom_minimum_size = container_size
