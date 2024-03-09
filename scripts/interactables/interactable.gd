extends Area3D

class_name Interactable

@export var enabled := true
@export var message := "Press F to interact"


func interact(node):
	if enabled:
		_effect(node)


func _effect(node):
	pass

