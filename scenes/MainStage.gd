extends Spatial

const path_stone = "res://scenes/Stone.tscn"
const stone_number = 20

func _ready():
	load_stone(1)

func _process(_delta):
	pass
		
func load_stone(offset_z: float):
	var location = get_node("Path/PathSpawnLocation")
	location.unit_offset = rand_range(0, 1) 
	location.h_offset = rand_range(-1, 1) 
	var pos = location.global_transform.origin
	
	for _i in range (0, stone_number):
		pos.z = rand_range(-offset_z,-offset_z*100)
		var stone = load(path_stone).instance()
		stone.global_transform.origin = pos
		add_child(stone)
		
	

