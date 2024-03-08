extends Node


signal initialize_enemies


var min_enemy_count := 5
var max_enemy_count := 5
var enemies_initialized := false
var remaining_enemies : int


func _ready():
	connect("initialize_enemies", activate_enemies)


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
		print("Initiated enemy ", i + 1, " of ", enemy_amount)
	
	remaining_enemies = enemy_amount
	print("Enemies initialized; begin the hunt.")
	enemies_initialized = true


func calculate_enemy_count() -> int:
	var number = randi_range(min_enemy_count, max_enemy_count)
	return number


func trigger_active_enemy_aggressive():
	if not enemies_initialized:
		await initialize_enemies
	
	get_tree().call_group("ActiveEnemy", "trigger_aggressive")


func enemy_slain():
	remaining_enemies -= 1
	
	if remaining_enemies <= 0:
		EndUi.enable_end_ui("THE ANOMALIES ARE SLAIN", true, "For Now...")
