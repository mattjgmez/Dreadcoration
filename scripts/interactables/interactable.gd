extends Area3D

class_name Interactable

@export var enabled := true
@export var message := "Press F to interact"
@export var disabled_message := ""


func interact(node):
	if enabled:
		_effect(node)


func _effect(_node):
	pass

