@tool
extends Node

signal healed(amount : int)
signal damaged(amount : int)
signal died()

@export var maximum_health : int = 100

var current_health : int
var dead := false
var invulnerable := false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		current_health = maximum_health


func take_damage(amount):
	if dead or invulnerable:
		return
	
	current_health -= amount
	damaged.emit(amount)
	
	if current_health <= 0:
		current_health = 0
		dead = true
		died.emit()


func heal_damage(amount):
	if dead:
		return
	
	var missing_health = maximum_health - current_health
	var healing_amount = clampi(amount, 0, missing_health)
	current_health += healing_amount
	healed.emit(healing_amount)
