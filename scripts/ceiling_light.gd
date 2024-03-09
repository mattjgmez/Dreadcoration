extends Node3D


@export_range(0.0, 1.0, 0.01) var flicker_chance := 0.0
@export var start_on := true

@onready var animator := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if start_on:
		turn_on()


func turn_on():
	var random_float = randf()
	
	$ceiling_light/LightHum.playing = true
	
	if random_float <= flicker_chance:
		animator.play("flicker")
	else:
		animator.play("on")	
