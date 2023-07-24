extends Spatial

class_name Boat

onready var cannonBallScene = preload("res://scenes/gameplay/CannonBall.tscn")

enum BOAT_STATE {
	DEFAULT,
	DIE,
	RUSH
}

const BASE_SPEED = 25
const RUSH_SPEED = 55
const TURN_SPEED = deg2rad(60)
const MAX_Z_LEAN = deg2rad(15)
const Z_LEAN_SPEED = deg2rad(10)
const Z_LEAN_RECOVER = deg2rad(30)

var currentSpeed = BASE_SPEED
var currentRotation = 0
var currentZLean = 0
var currentState = BOAT_STATE.DEFAULT setget setState

var lastAccInput = 0
var just_pressed_shoot = false
var just_released_shoot = false

onready var boat = $"%boat_pivot"
onready var model = $"%model_pivot"
onready var pirateLookAt = $"%pirate_look_at"
onready var targetingTurret = $"%TargetingTurret"
onready var animationPlayer = $"%AnimationPlayer"

onready var radialMinigame = $"%RadialMinigame"

func setState(new_state):
	currentState = new_state
	
	match currentState:
		BOAT_STATE.DEFAULT:
			currentSpeed = BASE_SPEED
		BOAT_STATE.DIE:
			currentSpeed = 0
			# play death animation and set the first animation tracks to the current position
			var die_animation = animationPlayer.get_animation("die")
			var rotation_track_idx = die_animation.find_track("boat_pivot/model_pivot:rotation_degrees")
			die_animation.track_set_key_value(rotation_track_idx, 0, model.rotation_degrees)
			var scale_track_idx = die_animation.find_track("boat_pivot/model_pivot:scale")
			die_animation.track_set_key_value(scale_track_idx, 0, model.scale)
			animationPlayer.play("die")
			radialMinigame.stop()
		BOAT_STATE.RUSH:
			currentSpeed = RUSH_SPEED

# Called when the node enters the scene tree for the first time.
func _ready():
	radialMinigame.connect("success", self, "shoot")

func _input(event: InputEvent) -> void:
	if OS.get_name() == "Windows":
		if event is InputEvent:
			if event.is_action("shoot"):
				if event.pressed:
					just_pressed_shoot = true
				else:
					just_released_shoot = true
					
	elif OS.get_name() == "Android":
		if event is InputEventScreenTouch:
			if event.pressed:
				just_pressed_shoot = true
			else:
				just_released_shoot = true
			

func _process(delta):
	match currentState:
		BOAT_STATE.DEFAULT:
			updateStateDefault(delta)
		BOAT_STATE.DIE:
			updateStateDie(delta)
		BOAT_STATE.RUSH:
			updateStateRush(delta)
	
	just_pressed_shoot = false
	just_released_shoot = false

func updateStateDefault(delta):
	updateMovement(delta)
	updateTargeting()
	updateShoot()

func updateStateDie(delta):
	pass

func updateStateRush(delta):
	updateMovement(delta)

func updateMovement(delta):
	#	movement update
	var acc_input = Input.get_accelerometer()
	var _move_input = Vector2.ZERO
	
	if acc_input == Vector3.ZERO:
		if Input.is_action_pressed("left"):
			_move_input.x += 1
		if Input.is_action_pressed("right"):
			_move_input.x -= 1
	else:
		# android
		if abs(acc_input.x) > 1:
#			var input_now = acc_input.x
#			if abs(input_now - lastAccInput) > .1 || sign(input_now) == -sign(currentRotation):
			_move_input.x = sign(acc_input.x) * -1
#				lastAccInput = input_now
	
	currentRotation += TURN_SPEED * _move_input.x * delta
	
	if _move_input.x == 0:
		currentZLean = move_toward(currentZLean, 0, Z_LEAN_RECOVER * delta)
	else:
		currentZLean = move_toward(currentZLean, MAX_Z_LEAN * _move_input.x, Z_LEAN_RECOVER * delta)
		
	var _lean_rotated = Basis().rotated(Vector3(0,0,1), currentZLean)
	model.transform.basis = _lean_rotated
	
	transform.basis = Basis().rotated(Vector3(0, 1, 0), currentRotation)
	
	#	boat.global_translate(-model.transform.basis.z * BASE_SPEED * delta)
	global_translate(-model.global_transform.basis.z * BASE_SPEED * delta)

func updateTargeting():
	targetingTurret.updateTarget()

func updateShoot():
	if targetingTurret.target == null:
		radialMinigame.stop()
		return
		
	if just_pressed_shoot :
		if !radialMinigame.visible:
			radialMinigame.start()
	if just_released_shoot:
		if radialMinigame.visible:
			radialMinigame.stop()

func _on_Area_area_entered(area: Area) -> void:
	if area.collision_layer & CollisionLayers.OBSTACLE:
		die()
		
func die():
	self.currentState = BOAT_STATE.DIE
	
	yield(get_tree().create_timer(3), "timeout")
	respawn()
	
func respawn():
	self.currentState = BOAT_STATE.DEFAULT
	animationPlayer.play("RESET")
	
func shoot():
	if currentState != BOAT_STATE.DEFAULT:
		return
		
	var new_cannonball = cannonBallScene.instance()
	var projectiles = get_tree().get_nodes_in_group("projectiles")[0]
	projectiles.add_child(new_cannonball)
	
	var path = targetingTurret.getCannonballPath()
	if path == []:
		return
	new_cannonball.init(path, targetingTurret.target)
	
