extends CSGPolygon

func _process(delta: float) -> void:
	pass
	# this for SpatialMaterial
	material.uv1_offset = Vector3(Time.get_ticks_msec() * 0.0002, 0, 0)

	# this for MaterialShader
#	material.set_shader_param("uv1_offset", Vector3(Time.get_ticks_msec() * 0.0002, 0, 0))
