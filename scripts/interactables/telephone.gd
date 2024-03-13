extends Interactable


@onready var animator = $AnimationPlayer


func _effect(_node):
	$Voicemail.playing = true
	enabled = false
