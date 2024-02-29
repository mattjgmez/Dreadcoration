extends CharacterBody3D


@export_range(0.0, 100.0) var SPEED = 5.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var mouse_sensitivity = 0.15 / (get_viewport().get_visible_rect().size.x/1152.0)
@onready var cam = $Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		rotation_degrees.y += event.relative.x * -mouse_sensitivity
		cam.rotation_degrees.x += event.relative.y * -mouse_sensitivity
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("gameplay_left", "gameplay_right", "gameplay_forward", "gameplay_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
