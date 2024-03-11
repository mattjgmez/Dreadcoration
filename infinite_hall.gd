extends Node3D


var light_delay := 1.0
var increment := 0.2

@onready var lights := $Lights.get_children()


func _on_death_trigger_body_entered(body):
	if body.is_in_group("Player"):
		body.flashlight.visible = false
		var size = lights.size()
		print(size)
		for i in size:
			var next_light = lights.pop_back()
			var time = clampf(light_delay - increment * i, 0.1, light_delay)
			print(time)
			
			await get_tree().create_timer(time).timeout
			if next_light:
				next_light.turn_off()
		
		SceneLoader.call_deferred("load_scene", GameManager.current_scene, "secret_ending", false)
