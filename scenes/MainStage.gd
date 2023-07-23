extends Spatial

onready var stoneScene = preload("res://scenes/Stone.tscn")
onready var pirateTowerScene = preload("res://scenes/gameplay/PirateTower.tscn")
const stone_number = 20

func _ready():
	load_stone(1)

func _process(_delta):
	pass
		
func load_stone(offset_z: float):
	
	for _i in range (0, 100):
		var location = get_node("Path/PathSpawnLocation")
		location.unit_offset = float(_i) / 100
		location.h_offset = rand_range(-1, 1) 
		var pos = location.global_transform.origin
		pos *= 51
		var scene = stoneScene
		if randi() % 2:
			scene = pirateTowerScene
		var stone = scene.instance()
		stone.global_transform.origin = pos
		add_child(stone)
		
