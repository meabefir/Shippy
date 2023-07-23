extends Spatial

onready var pirate_spawn_points = $"%pirate_spawn_points"
onready var pirates = $"%pirates"

onready var pirate_scene = preload("res://scenes/gameplay/Pirate.tscn")

func _ready() -> void:
	
	var n_pirates_to_spawn = randi() % 3 + 1
	
	var spawn_points = pirate_spawn_points.get_children()
	spawn_points.shuffle()

	for i in range(n_pirates_to_spawn):
		var pos_spawn_point = spawn_points[i].global_transform.origin
		
		var new_pirate = pirate_scene.instance()
		pirates.add_child(new_pirate)
		
		new_pirate.global_transform.origin = pos_spawn_point
