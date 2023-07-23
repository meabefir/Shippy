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
	var distance_to_target = global_transform.origin.distance_to(target.global_transform.origin)
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)
	
	var dir_to_target = (target.global_transform.origin - global_transform.origin).normalized()
	
	var n = 40
	for i in range(n):
		st.add_color(Color(1,0,0))
		var pos = dir_to_target * (float(i) / n) * distance_to_target
		st.add_vertex(pos)	
		st.add_index(i)

	mesh = st.commit();
