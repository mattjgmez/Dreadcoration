extends Node


var current_scene : Node


var scene_dictionary := {
	"loading_screen" : "res://scenes/interface/loading_scene.tscn",
	"scene1" : "res://scenes/levels/level_1.tscn"
}

var config := {
	"scenes" : scene_dictionary,
	"loading_screen" : scene_dictionary["loading_screen"],
	#"path_to_progress_bar" : "Container/ProgressBar"
}


func _ready():
	SceneLoader.set_configuration(config)

