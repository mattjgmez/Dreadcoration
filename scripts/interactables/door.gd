extends Interactable


@onready var animator = $AnimationPlayer


func _effect(_node):
	animator.play("open_normal")
