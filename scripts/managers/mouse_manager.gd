extends Node

const CAPTURED := Input.MOUSE_MODE_CAPTURED
const RELEASED := Input.MOUSE_MODE_VISIBLE

var gameplay_active := true


func _ready():
	Input.mouse_mode = CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		#Input.mouse_mode = RELEASED
	
	if event.is_action_pressed("gameplay_action") and gameplay_active:
		if Input.mouse_mode == RELEASED:
			Input.mouse_mode = CAPTURED
