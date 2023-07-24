extends Spatial

onready var stoneScene = preload("res://scenes/Stone.tscn")
onready var pirateTowerScene = preload("res://scenes/gameplay/PirateTower.tscn")

onready var location = $"%PathSpawnLocation"

func _ready():
	randomize()
	load_stone()

func _process(_delta):
	pass
		
func load_stone():
	var n = 22
	for _i in range (0, n):
		location.unit_offset = float(_i) / n
		location.h_offset = rand_range(-1, 1) 
		var pos = location.global_transform.origin
		pos *= 51
		var scene = stoneScene
		if randi() % 2:
			scene = pirateTowerScene
		var stone = scene.instance()
		add_child(stone)
		stone.global_transform.origin = pos
