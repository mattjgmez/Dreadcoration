extends Node

const CAPTURED := Input.MOUSE_MODE_CAPTURED
const RELEASED := Input.MOUSE_MODE_VISIBLE

var gameplay_active := true
var screen_resolutions := [
	Vector2(1920, 1080),
	Vector2(860, 520)
]

func _ready():
	Input.mouse_mode = CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Bro close the shit")
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		#Input.mouse_mode = RELEASED
	
	if event.is_action_pressed("gameplay_action") and gameplay_active:
		if Input.mouse_mode == RELEASED:
			Input.mouse_mode = CAPTURED
	
	if event.is_action_pressed("gameplay_interact"):
		var next_res = screen_resolutions.pop_back()
		get_tree().root.content_scale_size = next_res
		screen_resolutions.push_front(next_res)
		print("Resolution set to:", next_res.x, "/", next_res.y)
