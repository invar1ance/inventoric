class_name GridPositionHelper

static func get_idx(size_v: int, point: Vector2i) -> int:
	return point.x * size_v + point.y
	
static func get_point(size_v: int, idx: int) -> Vector2i:
	return Vector2i(idx / size_v, idx % size_v)
