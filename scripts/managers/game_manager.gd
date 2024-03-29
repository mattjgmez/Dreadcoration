extends Node


var current_scene : Node
var current_scene_string : String


var scene_dictionary := {
	"tutorial" : "res://scenes/levels/tutorial.tscn",
	"level_1" : "res://scenes/levels/level_1.tscn",
	"secret_ending" : "res://scenes/levels/secret_ending.tscn"
}

var config := {
	"scenes" : scene_dictionary,
	"loading_screen" : "res://scenes/interface/loading_scene.tscn",
	#"path_to_progress_bar" : "Container/ProgressBar"
}


func _ready():
	SceneLoader.set_configuration(config)

