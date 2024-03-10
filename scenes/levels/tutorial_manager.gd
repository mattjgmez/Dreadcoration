extends Node


@onready var enemy = $"../PostProcessing/SubViewport/EnemyTutorial"
@onready var player = $"../PostProcessing/SubViewport/Player"
@onready var reload_label = $"../PostProcessing/SubViewport/Player/HUD/ReloadLabel"
@onready var enemy_point = $EnemyPoint

var cutscene_played := false
var guns_collected := false


func _on_elevator_main_elevator_closed():
	print(GameManager.current_scene)
	SceneLoader.load_scene(GameManager.current_scene, "level_1")


func _on_bag_of_guns_guns_collected():
	reload_label.visible = true
	guns_collected = true
	
	$"../PostProcessing/SubViewport/NavigationRegion3D/ElevatorMain".open_elevator()
	$"../PostProcessing/SubViewport/CeilingLightElevator".turn_on()
	
	EnemyManager.remaining_enemies = 20


func _input(event):
	if event.is_action_pressed("gameplay_reload"):
		reload_label.visible = false


func _on_enemy_trigger_body_entered(body):
	if not body.is_in_group("Player") or cutscene_played or not guns_collected:
		return
	
	cutscene_played = true
	
	$"../PostProcessing/SubViewport/Environment/CeilingLight5".turn_off()
	$"../PostProcessing/SubViewport/CeilingLightElevator".turn_off()
	
	await get_tree().create_timer(1.0).timeout
	
	enemy.global_position = enemy_point.global_position
	enemy.start_following_player()
	
	$"../PostProcessing/SubViewport/Environment/CeilingLight5".turn_on()
	$"../PostProcessing/SubViewport/CeilingLightElevator".turn_on()
