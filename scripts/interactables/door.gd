extends Interactable


@onready var animator = $AnimationPlayer


func _effect(_node):
	animator.play("open_normal")


func slam_open():
	animator.play("open_slam")
	enabled = false
