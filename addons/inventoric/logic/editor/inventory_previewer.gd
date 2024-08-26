class_name ICInventoryPreviewer

var _canvas_item_rid: RID

func generate_canvas_item(view: Node) -> void:
	clear_canvas_item()
	_canvas_item_rid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(_canvas_item_rid, view.get_canvas_item())
	
func clear_canvas_item() -> void:
	if _canvas_item_rid:
		RenderingServer.canvas_item_clear(_canvas_item_rid)
		RenderingServer.free_rid(_canvas_item_rid)
		
func handles(view: Object) -> bool:
	return false

func redraw(view: ICInventoryView) -> void:
	pass
