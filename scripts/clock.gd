extends Node3D


@onready var timer := $GracePeriod
@onready var animator := $AnimationPlayer


func _on_grace_period_timeout():
	$Audio/TimeUp.playing = true
	animator.stop(true)
	animator.play("time_up")


# Used so that the animator can call the EnemyManager
func call_enemy_manager():
	EnemyManager.activate_enemies()
