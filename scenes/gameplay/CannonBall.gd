extends Spatial

class_name CannonBall

export var duration = .5

var path_follow: PathFollow = null
var target = null

var currentPathProgress = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(points, _target):
	target = _target
	target.remove_from_group("targetable_pirate")
	
	var path = Path.new()
	var curve = Curve3D.new()
	
	for p in points:
		curve.add_point(p)
	path.curve = curve
		
	path_follow = PathFollow.new()
	path.add_child(path_follow)
	add_child(path)
	
func _process(delta: float) -> void:
	if path_follow == null:
		return
	
	currentPathProgress += delta / duration
	if currentPathProgress >= 1:
		if is_instance_valid(target):
			target.queue_free()
		queue_free()
		return
	path_follow.unit_offset = currentPathProgress
	
	global_transform.origin = path_follow.transform.origin
