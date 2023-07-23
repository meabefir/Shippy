extends Spatial

class_name Pirate

onready var model_pivot = $"%model_pivot"
onready var center = $"%center"
var boat = null

func _ready() -> void:
	var models = model_pivot.get_children()
	
	var idx = randi() % 3
	
	for i in range(3):
		if i == idx:
			continue
		
		models[i].visible = false

	boat = get_tree().get_nodes_in_group("boat")[0]

func _process(delta: float) -> void:
	if boat == null:
		return
		
	var boat_look_at = boat.pirateLookAt.global_transform.origin
	var look_at_pos = Vector3(boat_look_at.x, global_transform.origin.y, boat_look_at.z)
	global_transform = global_transform.looking_at(look_at_pos, Vector3.UP)
