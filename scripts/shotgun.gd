extends Node3D

@export var ready_to_fire := true
@export_range(0.0, 100.0) var knockback_force := 50.0

@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/CollisionShape3D
@onready var animation_player = $AnimationPlayer
@onready var muzzle_flash = $MuzzleFlash
@onready var muzzle_flash_mesh = $MuzzleFlash/MuzzleFlashMesh


func fire_weapon():
	if not ready_to_fire:
		return
	
	hitbox_shape.disabled = false
	animation_player.play("gun_shoot")
	
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


