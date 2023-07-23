extends CSGPolygon

func _process(delta: float) -> void:
	material.uv1_offset = Vector3(Time.get_ticks_msec() * 0.0002, 0, 0)
