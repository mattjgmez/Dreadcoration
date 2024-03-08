extends RigidBody3D


const OCC_RAY_TARGET_Y_OFFSET = 1.0

@export var speed = 5.0
@export var target_player : CharacterBody3D
@export_range(0.0, 10.0) var player_kill_range := 2.0

var occlusion_check_rays : Array[RayCast3D]
var seen_currently := false
var seen_previously := false
var active := false
var angry := false
var killing_player := false
var in_center_screen := false

@onready var ray_holder := $RayHolder
@onready var visible_notifier := $LoSAlert
@onready var nav_agent := $NavigationAgent3D
@onready var health := $Health
@onready var animation := $AnimationPlayer


func _ready():
	for r in occlusion_check_rays:
		r.target_position = (target_player.global_position - r.global_position) * self.basis
		r.target_position.y += OCC_RAY_TARGET_Y_OFFSET


func _physics_process(delta):
	# If this enemy is not active or has no target, we do nothing
	if not active:
		return
	
	if not target_player:
		return
	
	seen_currently = await is_viewed()
	
	if killing_player and (seen_currently or angry) and (in_center_screen or angry):
		target_player.health.take_damage(1000)
	
	if seen_currently and not angry:
		seen_previously = true
		return
	
	if not seen_previously and not angry:
		return
	
	if global_position.distance_to(target_player.global_position) <= player_kill_range:
		target_player.call_deferred("trigger_player_caught")
		killing_player = true
		return
	
	handle_movement(delta)


func handle_movement(delta):
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	
	if angry:
		var s = clampf(speed, speed + delta * 2.0, 20.0)
		speed = s
	
	# Movement directions
	var direction := Vector3.ZERO
	nav_agent.target_position = target_player.global_position
	direction = nav_agent.get_next_path_position() - global_position
	direction.y = 0
	direction = direction.normalized()
	
	# Look direction
	if nav_agent.get_current_navigation_path():
		var where_to_look = nav_agent.get_next_path_position()
		where_to_look.y = self.global_position.y
		if where_to_look != self.global_position:
			look_at(where_to_look, Vector3.UP)
			global_rotation = Vector3(0.0, global_rotation.y, 0.0)
	
	# Apply velocity
	var velocity = direction * speed * delta
	move_and_collide(velocity)


func start_following_player():
	await get_tree().physics_frame
	
	target_player = get_tree().get_first_node_in_group("Player")
	
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
	
	health.invulnerable = false
	
	active = true
	nav_agent.process_mode = Node.PROCESS_MODE_INHERIT


func stop_following_player():
	await get_tree().physics_frame
	health.invulnerable = true
	
	active = false
	nav_agent.process_mode = Node.PROCESS_MODE_DISABLED


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


func on_died():
	stop_following_player()
	animation.play("death")
	remove_from_group("ActiveEnemy")


func trigger_aggressive():
	angry = true
	$Audio/NoAmmoScream.playing = true
	animation.play("aggression")
