extends CanvasLayer


@onready var animation := $AnimationPlayer


func enable_death_ui():
	animation.play("fade_in")
	MouseManager.gameplay_active = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func load_main_menu():
	# Call scene loader to go to main menu
	pass


func reload_level():
	SceneLoader.load_scene(GameManager.current_scene, GameManager.current_scene_string)
	
	MouseManager.gameplay_active = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	EnemyManager.enemies_initialized = false
	
	animation.play("RESET")
