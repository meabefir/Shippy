extends Path

func _ready():
	curve.clear_points()
	for i in range(0, 10000):
		var pos = Vector3(sin(float(i)/100)*3 ,0,-i/50)
		curve.add_point(pos)

