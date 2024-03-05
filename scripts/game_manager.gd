extends Node


var scene_dictionary := {
	"scene1" : "res://scenes/levels/post_processing.tscn"
}

var config := {
	"scenes" : scene_dictionary
}


func _ready():
	SceneLoader.set_configuration(config)

