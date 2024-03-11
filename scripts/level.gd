extends Node


@export var scene_name : String
@export var go_to_last_scene := false


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.current_scene = self
	
	if not go_to_last_scene:
		GameManager.current_scene_string = scene_name
