extends ColorRect

signal success

var speed = 1

var pin
var target
var targetMargin

var dir
var running = false

onready var shader = material as ShaderMaterial 

func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	if !running:
		return
	
	if dir == 1:
		pin = move_toward(pin, 1, speed * delta)
		if pin == 1:
			dir = -1
	else:
		pin = move_toward(pin, 0, speed * delta)
		if pin == 0:
			dir = 1
			
	shader.set_shader_param("u_pin", pin)
	
func start():
	running = true
	visible = true
	pin = randf()
	shader.set_shader_param("u_pin", pin)
	target = randf()
	shader.set_shader_param("u_target", target)
	targetMargin = rand_range(.05, .2)
	shader.set_shader_param("u_targetMargin", targetMargin)
	
	dir = (randi() % 2 ) * 2 - 1
	
	speed = max(1, pow(targetMargin, 1.5))

func stop():
	# weird bug that triggered mouse up on game start which in turn triggered this
	if !running:
		return
	
	running = false
	visible = false
	
	if abs(target - pin) <= targetMargin / 2:
		emit_signal("success")
