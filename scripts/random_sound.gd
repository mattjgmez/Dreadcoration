extends AudioStreamPlayer3D

@export var sound_list := Array()
@export var min_replay_time := 1.0
@export var max_replay_time := 5.0
@export var min_pitch := 1.0
@export var max_pitch := 1.0
@export var sound_must_finish := true

var sound_index := 0

@onready var audio_timer := $"../AudioTimer"


func initialize_audio_timer():
	audio_timer.start(randf_range(min_replay_time, max_replay_time));


func trigger_random_sound():
	if not playing or not sound_must_finish:
		pitch_scale = randf_range(min_pitch, max_pitch)
		
		# Randomly pick a sound that is not the one we just played.
		sound_index = sound_index + int(randf_range(0.0, sound_list.size() - 1))
		sound_index %= sound_list.size()
		stream = sound_list[sound_index]
		play()
