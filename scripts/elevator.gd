extends Node3D

signal elevator_closed

@export var close_on_exit := true
@export var open_on_timer := false
@export_range(1.0, 20.0, 0.01) var open_timer := 2.0

@onready var animator := $AnimationPlayer


func _ready():
	if open_on_timer:
		await get_tree().create_timer(open_timer).timeout
		open_elevator()


func open_elevator():
	animator.play("open")


func close_elevator():
	animator.play("close")


func _on_elevator_exited(body):
	if close_on_exit and body.is_in_group("Player"):
		close_elevator()


func _on_elevator_entered(body):
	if not close_on_exit and body.is_in_group("Player"):
		await get_tree().create_timer(1.0).timeout
		close_elevator()
