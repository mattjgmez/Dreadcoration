extends Node


@onready var enemy = $"../PostProcessing/SubViewport/EnemyTutorial"
@onready var player = $"../PostProcessing/SubViewport/Player"
@onready var reload_label = $"../PostProcessing/SubViewport/Player/HUD/ReloadLabel"


func _on_elevator_main_elevator_closed():
	SceneLoader.load_scene(GameManager.current_scene, "level_1")


func _on_bag_of_guns_guns_collected():
	reload_label.visible = true
	
	enemy.start_following_player()
	enemy.angry = true
	enemy.animation.play("caught_player_start")
	
	$"../PostProcessing/SubViewport/NavigationRegion3D/ElevatorMain".open_elevator()
	$"../PostProcessing/SubViewport/CeilingLightElevator".turn_on()
	
	EnemyManager.remaining_enemies = 20


func _input(event):
	if event.is_action_pressed("gameplay_reload"):
		reload_label.visible = false
