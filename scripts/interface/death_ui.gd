extends CanvasLayer


var ui_active := false


@onready var animation := $AnimationPlayer


func enable_end_ui(label : String, include_subtext := false, subtext := ""):
	ui_active = true
	$UI/Label.text = label
	$UI/Subtext.text = subtext
	
	if not include_subtext:
		animation.play("fade_in")
	else:
		animation.play("fade_in_subtext")
	
	MouseManager.gameplay_active = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func load_main_menu():
	# Call scene loader to go to main menu
	pass


func reload_level():
	SceneLoader.call_deferred("load_scene", GameManager.current_scene, GameManager.current_scene_string)
	
	MouseManager.gameplay_active = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	EnemyManager.enemies_initialized = false
	
	animation.play("RESET")
	ui_active = false
