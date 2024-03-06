extends Node3D

@export var ready_to_fire := true
@export_range(0.0, 100.0) var knockback_force := 50.0
@export_range(0, 20, 1) var max_reloads := 4
@export var reloading := false

var max_ammo := 2
var current_ammo := 2
var current_reloads : int

@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/CollisionShape3D
@onready var animation_player = $AnimationPlayer
@onready var muzzle_flash = $MuzzleFlash
@onready var muzzle_flash_mesh = $MuzzleFlash/MuzzleFlashMesh
@onready var thrown_model = preload("res://scenes/weapons/thrown_shotgun.tscn")
@onready var model = $Model

func _ready():
	current_reloads = max_reloads

func fire_weapon():
	if not ready_to_fire:
		return
	
	if current_ammo == 0:
		animation_player.play("no_ammo")
		return
	
	hitbox_shape.disabled = false
	animation_player.play("gun_shoot")
	current_ammo -= 1
	
	await Engine.get_main_loop().physics_frame
	await Engine.get_main_loop().physics_frame
	
	hitbox_shape.disabled = true


func deal_damage(body : Node3D):
	if body.is_in_group("Damageable"):
		body.health.take_damage(1000)
	
	if body is RigidBody3D:
		var target_direction := (body.global_position - self.global_position).normalized()
		var knockback_vector := target_direction * knockback_force
		body.apply_impulse(knockback_vector)


func reload() -> int:
	if not ready_to_fire or current_reloads <= 0 or reloading:
		return current_reloads
	
	reloading = true
	$ReloadTimer.start()
	
	current_reloads -= 1
	current_ammo = max_ammo
	
	if current_reloads > 0:
		animation_player.play("reload")
	else:
		model.visible = false
		ready_to_fire = false
		$Audio/NoAmmoScream.playing = true
		EnemyManager.trigger_active_enemy_aggressive()
	
	var instance = thrown_model.instantiate()
	add_child(instance)
	instance.top_level = true
	instance.global_position = model.global_position
	
	var throw_direction = -global_transform.basis.z
	instance.apply_impulse(throw_direction * 10)
	
	return current_reloads


func _on_reload_timer_timeout():
	reloading = false
