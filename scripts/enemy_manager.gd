extends Node

var min_enemy_count := 5
var max_enemy_count := 5
var enemies_initialized := false


# Called when the node enters the scene tree for the first time.
func activate_enemies():
	if enemies_initialized:
		return
	
	var enemies := get_tree().get_nodes_in_group("Enemy")
	var enemy_amount := calculate_enemy_count()
	
	if not enemies:
		printerr("No enemies found, enemies not initialized")
		return
	
	for i in enemy_amount:
		var random_enemy = enemies.pick_random()
		random_enemy.call_deferred("start_following_player")
		random_enemy.add_to_group("ActiveEnemy")
	
	enemies_initialized = true


func calculate_enemy_count() -> int:
	var number = randi_range(min_enemy_count, max_enemy_count)
	return number


func trigger_active_enemy_aggressive():
	get_tree().call_group("ActiveEnemy", "trigger_aggressive")

