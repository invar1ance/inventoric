class_name ICInventoryPreviewer

static func create_canvas_item(view: Node) -> RID:
	var canvas_item = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(canvas_item, view.get_canvas_item())
	
	return canvas_item
	
static func clear_canvas_item(item: RID) -> void:
	RenderingServer.canvas_item_clear(item)
	RenderingServer.free_rid(item)
		
static func handles(view: Object) -> bool:
	return false

static func redraw(canvas_item: RID, view: ICInventoryView) -> void:
	pass
