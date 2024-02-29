@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Health", "Node", preload("health_node.gd"), preload("hearts.svg"))
	pass


func _exit_tree():
	remove_custom_type("Health")
	pass
