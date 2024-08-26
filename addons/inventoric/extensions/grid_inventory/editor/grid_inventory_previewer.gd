extends ICInventoryPreviewer

static func handles(view: Object) -> bool:
	return view is GridInventoryView and GridLayoutManager.editor_render_ready(view)

static func draw(canvas_item: RID, view: ICInventoryView) -> void:
	var rect = view.get_global_rect()
	var container_size = GridLayoutManager.get_container_size(view)
	
	var tl = Vector2.ZERO
	var br = tl + container_size
	var bl = Vector2(tl.x, br.y)
	var tr = Vector2(br.x, tl.y)
	
	RenderingServer.canvas_item_add_line(canvas_item, tr, br, view.debug_color_1, 1.5)
	RenderingServer.canvas_item_add_line(canvas_item, tl, bl, view.debug_color_1, 1.5)
	RenderingServer.canvas_item_add_line(canvas_item, tl, tr, view.debug_color_1, 1.5)
	RenderingServer.canvas_item_add_line(canvas_item, bl, br, view.debug_color_1, 1.5)
	
	var calculated_x = tl.x + view.slot_view_config.size_h + view.config.spacing_h * 0.5
	for x in range(1, view.inventory.config.size_h):
		var from = Vector2(calculated_x, tl.y)
		var to = Vector2(calculated_x, br.y)
		RenderingServer.canvas_item_add_line(canvas_item, from, to, view.debug_color_1, 1.5)
		calculated_x += view.slot_view_config.size_h + view.config.spacing_h
	
	var calculated_y = tl.y + view.slot_view_config.size_v + view.config.spacing_v * 0.5
	for y in range(1, view.inventory.config.size_v):
		var from = Vector2(tl.x, calculated_y)
		var to = Vector2(tr.x, calculated_y)
		RenderingServer.canvas_item_add_line(canvas_item, from, to, view.debug_color_1, 1.5)
		calculated_y += view.slot_view_config.size_v + view.config.spacing_v
	
	var slot_size = Vector2(view.slot_view_config.size_h, view.slot_view_config.size_v)
	var slot_padding = Vector2(view.slot_view_config.padding_h, view.slot_view_config.padding_v)
	var item_size = Vector2(view.slot_view_config.size_h, view.slot_view_config.size_v) - Vector2(view.slot_view_config.padding_h, view.slot_view_config.padding_v) * 2
	var spacing_offset = Vector2.ZERO
	for item_x in view.inventory.config.size_h:
		for item_y in view.inventory.config.size_v:
			var item_pos = tl + Vector2(item_x, item_y) * slot_size + slot_padding + spacing_offset
			var item_rect = Rect2(item_pos, item_size)
			RenderingServer.canvas_item_add_rect(canvas_item, item_rect, view.debug_color_2)
			spacing_offset.y += view.config.spacing_v
		spacing_offset.y = 0
		spacing_offset.x += view.config.spacing_h
