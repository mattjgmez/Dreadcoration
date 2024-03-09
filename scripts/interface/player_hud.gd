extends Control


var shotgun_texture := preload("res://shotgun_UI.png")


@onready var remaining_gun_container := $RemainingGuns
@onready var interaction_label := $InteractionLabel


func set_remaining_guns(amount : int):
	var remaining_gun_rects := remaining_gun_container.get_children()
	var current_amount := remaining_gun_rects.size()
	
	var difference := amount - current_amount
	
	if difference < 0:
		for i in abs(difference):
			var rect = remaining_gun_rects.pop_back()
			rect.queue_free()
	elif difference > 0:
		for i in difference:
			var rect = TextureRect.new()
			remaining_gun_container.add_child(rect)
			rect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
			rect.texture = shotgun_texture


func enable_interaction_label(string : String):
	interaction_label.text = string
	interaction_label.visible = true


func disable_interaction_label():
	interaction_label.text = ""
	interaction_label.visible = false
