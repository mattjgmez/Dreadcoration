extends Interactable


@onready var animator = $AnimationPlayer


func _effect(node):
	animator.play("open_normal")
