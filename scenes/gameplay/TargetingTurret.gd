extends MeshInstance

const MAX_DIST_TO_TARGET = 100

var target = null

onready var cube_scene = preload("res://test/Spatial.tscn")

func _ready() -> void:
	pass # Replace with function body.

func findTarget():
	var pirates = get_tree().get_nodes_in_group("pirate")
	
	if pirates.size() == 0:
		return
	
	var closest_pirate = pirates[0]
	var closest_distance = global_transform.origin.distance_to(closest_pirate.global_transform.origin)
	for i in range(1, pirates.size()):
		var current_distance = global_transform.origin.distance_to(pirates[i].global_transform.origin)
		
		if current_distance < closest_distance:
			closest_pirate = pirates[i]
			closest_distance = current_distance
	target =  closest_pirate
	
func _process(delta: float) -> void:
#	if target == null:
#		findTarget()
#		return
#
#	var distance_to_target = global_transform.origin.distance_to(target.global_transform.origin)
#	if distance_to_target > MAX_DIST_TO_TARGET:
#		findTarget()
#
#	if target == null:
#		return

	findTarget()
	if target == null:
		return
	
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)
	
	var distance_to_target = global_transform.origin.distance_to(target.center.global_transform.origin)
	var dir_to_target = (target.center.global_transform.origin - global_transform.origin).normalized()
	
	var path = getCannonballPath(false)
	
	for i in range(path.size()):
		st.add_color(Color(1,0,0))
		st.add_vertex(path[i])	
		st.add_index(i)

	mesh = st.commit();

func getCannonballPath(global = true):
	var ret = []
	
	if target == null:
		return
	var distance_to_target = global_transform.origin.distance_to(target.center.global_transform.origin)
	var dir_to_target = (target.center.global_transform.origin - global_transform.origin).normalized()
	
	var n = 40
	for i in range(n):
		var pos = dir_to_target * (float(i) / n) * distance_to_target
		if global:
			pos += global_transform.origin
		ret += [pos]
		
	return ret
