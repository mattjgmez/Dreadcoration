extends CharacterBody3D


const OCC_RAY_TARGET_Y_OFFSET = 0.5

@export var speed = 5.0
@export var target_player : CharacterBody3D

var occlusion_check_rays : Array[RayCast3D]
var is_looked_at := true
var follow_player := false

@onready var ray_holder := $RayHolder
@onready var visible_notifier := $LoSAlert
@onready var nav_agent := $NavigationAgent3D


func _ready():
	if not target_player:
		printerr(self.name + " has no player target")
		set_physics_process(false)
		return
	
	# Initiate rays
	for r in ray_holder.get_children():
		if r is RayCast3D:
			r.add_exception(self)
			r.add_exception(target_player)
			occlusion_check_rays.append(r)
	
	start_following_player.call_deferred()


func _physics_process(delta):
	if not follow_player:
		return
	
	is_looked_at = is_viewed()
	
	if is_looked_at:
		return
	
	# Movement directions
	var direction = Vector3.ZERO
	nav_agent.target_position = target_player.global_position
	direction = nav_agent.get_next_path_position() - global_position
	direction.y = 0
	direction = direction.normalized()
	
	# Look direction
	if nav_agent.get_current_navigation_path():
		var where_to_look = nav_agent.get_next_path_position()
		where_to_look.y = self.global_position.y
		if not where_to_look == self.global_position:
			look_at(where_to_look, Vector3.UP)
	
	# Apply velocity
	velocity = direction * speed * delta
	move_and_slide()


func start_following_player():
	await get_tree().physics_frame
	follow_player = true


func is_viewed() -> bool:
	var viewed = visible_notifier.is_on_screen()
	
	if not viewed:
		return viewed
	
	var colliding_rays = 0
	
	# Point raycasts to player and count collisions
	for r in occlusion_check_rays:
		r.target_position = (target_player.global_position - r.global_position) * self.basis
		r.target_position.y += OCC_RAY_TARGET_Y_OFFSET
		if viewed and r.is_colliding():
			colliding_rays += 1
	
	# Enemy is not visible if all rays are colliding
	if colliding_rays >= occlusion_check_rays.size():
		viewed = false
	
	return viewed