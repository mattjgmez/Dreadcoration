extends Node3D

@export var close_on_exit := true

@onready var animator := $AnimationPlayer


func open_elevator():
	animator.play("open")


func close_elevator():
	animator.play("close")


func _on_elevator_exited(body):
	if close_on_exit and body.is_in_group("Player"):
		close_elevator()


func _on_elevator_entered(body):
	if not close_on_exit and body.is_in_group("Player"):
		close_elevator()
