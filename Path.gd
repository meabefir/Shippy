extends Path

func _ready():
	curve.clear_points()
	for i in range(0,100):
		var pos = Vector3(sin(i/5),0,-i)
		curve.add_point(pos)

