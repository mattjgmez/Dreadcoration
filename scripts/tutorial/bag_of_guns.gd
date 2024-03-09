extends Interactable

signal guns_collected

@export var amount := 1


func _effect(node):
	var gun = node.gun
	
	gun.add_reloads(amount)
	node.hud.set_remaining_guns(gun.current_reloads)
	print("Remaining reloads: ", gun.current_reloads)
	
	enabled = false
	visible = false
	guns_collected.emit()
