extends CharacterBody3D


@export_range(0.0, 100.0) var SPEED = 5.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player_caught := false
var player_dead := false
var interactable


@onready var mouse_sensitivity = 0.15 / (get_viewport().get_visible_rect().size.x/1152.0)
@onready var cam = $Camera3D
@onready var gun = $Camera3D/Shotgun
@onready var health = $Health
@onready var animation = $AnimationPlayer
@onready var hud = $HUD
@onready var interaction = $Camera3D/InteractionDetection
@onready var flashlight = $Camera3D/SpotLight3D


func _ready():
	hud.set_remaining_guns(gun.current_reloads)


func _input(event):
	if event is InputEventMouseMotion and not EndUi.ui_active:
		rotation_degrees.y += event.relative.x * -mouse_sensitivity
		cam.rotation_degrees.x += event.relative.y * -mouse_sensitivity
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -40, 70)
	
	if player_dead or player_caught:
		return
	
	if event.is_action_pressed("gameplay_action"):
		fire_weapon()
	
	if event.is_action_pressed("gameplay_reload"):
		var remaining_reloads = gun.reload()
		hud.set_remaining_guns(remaining_reloads)
		print("Remaining reloads: ", remaining_reloads)
	
	if event.is_action_pressed("gameplay_interact") and interactable:
		interactable.interact(self)


func _physics_process(_delta):
	if player_caught or EndUi.ui_active:
		return
	
	handle_interaction()
	
	handle_movement()


func handle_movement():
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


func handle_interaction():
	if interaction.is_colliding() and interaction.get_collider().visible:
		interactable = interaction.get_collider()
		if interactable.enabled:
			hud.enable_interaction_label(interactable.message)
		else:
			hud.enable_interaction_label(interactable.disabled_message)
	else:
		hud.disable_interaction_label()
		interactable = null


func fire_weapon():
	gun.fire_weapon()


func trigger_player_caught():
	if (player_caught):
		return
	
	player_caught = true
	animation.play("caught")
	pass


func _on_health_died():
	player_dead = true
	hud.visible = false
	animation.play("death")
	pass


func show_death_ui():
	EndUi.enable_end_ui("A MOST UNWELCOME END")
	pass


func _on_center_detection_body_entered(body : Node3D):
	if body.is_in_group("ActiveEnemy"):
		body.in_center_screen = true


func _on_center_detection_body_exited(body : Node3D):
	if body.is_in_group("ActiveEnemy"):
		body.in_center_screen = false
