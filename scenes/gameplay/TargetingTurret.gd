extends MeshInstance

const MAX_TARGETING_DISTANCE = 100

var target = null

onready var cube_scene = preload("res://test/Spatial.tscn")

var updatedTargetThisFrame = false

func calculate_catmull_rom_spline(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, t: float) -> Vector3:
	var t2 = t * t
	var t3 = t2 * t

	var b1 = 0.5 * (-t3 + 2 * t2 - t);
	var b2 = 0.5 * (3 * t3 - 5 * t2 + 2);
	var b3 = 0.5 * (-3 * t3 + 4 * t2 + t);
	var b4 = 0.5 * (t3 - t2);

	var x = p0.x * b1 + p1.x * b2 + p2.x * b3 + p3.x * b4;
	var y = p0.y * b1 + p1.y * b2 + p2.y * b3 + p3.y * b4;
	var z = p0.z * b1 + p1.z * b2 + p2.z * b3 + p3.z * b4;

	# Calculate the point on the spline
	return Vector3(x, y, z)

func generate_spline(control_points: Array, resolution: int):
	var spline_points = []
	for i in range(control_points.size() - 3):
		for j in range(resolution):
			var t = float(j) / float(resolution)
			var point_on_spline = calculate_catmull_rom_spline(control_points[i], control_points[i + 1], control_points[i + 2], control_points[i + 3], t)
			spline_points.append(point_on_spline)
	return spline_points

func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if !updatedTargetThisFrame:
		mesh = null
	updatedTargetThisFrame = false
	pass
	
func updateTarget():
	updatedTargetThisFrame = true
	findTarget()
	if target == null or !is_instance_valid(target):
		mesh = null
		return
	
	var distance_to_target = global_transform.origin.distance_to(target.center.global_transform.origin)
	if distance_to_target > MAX_TARGETING_DISTANCE:
		mesh = null
		return
		
	var dir_to_target = (target.center.global_transform.origin - global_transform.origin).normalized()
	
	var path = getCannonballPath(false)
	
	var st = SurfaceTool.new()
	
	var thickness = 1	
	var half_thickness = thickness * .5
	var color = Color(1,0,0)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	if path.size() % 2 == 1:
		path.pop_back()
	for i in range(0, path.size(), 2):
		
		var perp = (path[i+1] - path[i]).cross(Vector3.UP).normalized()
		
		var p1 = path[i] + perp * half_thickness
		var p2 = path[i] + perp * -half_thickness
		var p3 = path[i+1] + perp * half_thickness
		var p4 = path[i+1] + perp * -half_thickness
		
		st.add_color(color)
		st.add_vertex(p1)
		st.add_color(color)
		st.add_vertex(p2)
		st.add_color(color)
		st.add_vertex(p3)
		st.add_color(color)
		st.add_vertex(p3)
		st.add_color(color)
		st.add_vertex(p2)
		st.add_color(color)
		st.add_vertex(p4)
		
	mesh = st.commit();

func findTarget():
	var pirates = get_tree().get_nodes_in_group("targetable_pirate")
	
	if pirates.size() == 0:
		return
	
	var closest_pirate = pirates[0]
	var closest_distance = global_transform.origin.distance_to(closest_pirate.global_transform.origin)
	for i in range(1, pirates.size()):
		var current_distance = global_transform.origin.distance_to(pirates[i].global_transform.origin)
		
		if current_distance < closest_distance:
			closest_pirate = pirates[i]
			closest_distance = current_distance
			
	if closest_distance < MAX_TARGETING_DISTANCE:
		target =  closest_pirate
	else:
		target = null	

func getCannonballPath(global = true):
	if !target:
		return []
		
	var from = global_transform.origin
	var to = target.center.global_transform.origin
	
	var y_off = -10
	var before_from = from + Vector3(0, y_off, 0)
	var after_to = to + Vector3(0, y_off, 0)
	
	var from_to_to = to - from
	var from_to_to_normalized: Vector3 = from_to_to.normalized()
	var one_third = from + from_to_to / 3
	var two_thirds = from + from_to_to * 2 / 3
	
	var rotation_axis = ((before_from - from).normalized()).cross(from_to_to.normalized()).normalized()
	var middle_distance = 20
	
#	var middle_1 = one_third + from_to_to_normalized.rotated(rotation_axis, deg2rad(90)) * middle_distance
#	var middle_2 = two_thirds + from_to_to_normalized.rotated(rotation_axis, deg2rad(90)) * middle_distance

	var middle_1 = one_third + Vector3.UP * middle_distance
	var middle_2 = two_thirds + Vector3.UP * middle_distance
	
	var ret = []
#	var points = [before_from, from, to, after_to]
	var points = [before_from, from, middle_1, middle_2, to, after_to]
#	for i in range(points.size()):
#		points[i] -= from
#	return points
	var spline = generate_spline(points, 20) # this should be even
	if !global:
		ret = []
		for p in spline:
#			ret += [p - from]
			ret += [global_transform.xform_inv(p)]
	else:
		ret = spline
		
	return ret
