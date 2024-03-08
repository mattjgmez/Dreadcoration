extends Node


@export var scene_name : String


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.current_scene = self
	GameManager.current_scene_string = scene_name
