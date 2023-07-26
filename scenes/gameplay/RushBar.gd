extends ColorRect

tool

onready var shader = material as ShaderMaterial

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	shader.set_shader_param("u_textureSize", rect_size)
