# The script is used to handle sound effects

extends Node # static class

# Nodes
var audio_player: AudioStreamPlayer
var wav_stream: AudioStreamWAV

# Built-in functions
# Called when the node enters the scene tree for the first time
func _ready():
	# Instantiate audio player
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player) # Add audio player as a child
	
	# Connect audio finished signal
	audio_player.connect("finished", Callable(self, "_on_audio_finished"))
	
	# Load WAV audio stream resource
	wav_stream = preload("res://assets/audio/music/Wake Up, Get Up, Get Out There.wav")

	# Assign stream and play
	audio_player.stream = wav_stream
	audio_player.volume_db = linear_to_db(0.5)
	audio_player.play()
	
# Called when the audio finishes
func _on_audio_finished():
	audio_player.play()
