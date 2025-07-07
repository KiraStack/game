extends CharacterBody2D

# Constants
@export var speed: float = 400 # Horizontal movement speed
@export var jump_force: float = 600 # Upward force applied on jump
@export var gravity: float = 30 # Gravity applied each frame when airborne
@export var limit: int = 2 # Max allowed jumps (e.g., double jump)
@export var active: bool = false # Enables double jump if true

# References
var jump_sound := preload("res://assets/audio/sfx/jump.wav") # Jump sound effect

# Nodes
var audio_player: AudioStreamPlayer # Audio player for jump sound

# Variables
var count: int # Tracks remaining jumps

func _ready():
	count = limit # Initialize jump count
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = jump_sound
	audio_player.bus = "sfx"
	add_child(audio_player) # Attach audio player node

func apply_gravity():
	# Apply gravity when not on floor, reset jump count otherwise
	if not is_on_floor():
		velocity.y += gravity
	else:
		count = limit

func move(direction: float):
	# Set horizontal velocity and move the character
	velocity.x = direction * speed
	move_and_slide()

func try_jump():
	# Handle jump logic: first jump or double jump if active and jumps remain
	if is_on_floor() and not active:
		jump()
	elif active and count > 0:
		jump()
		count -= 1

func jump():
	# Apply upward velocity and play jump sound effect
	velocity.y = - jump_force
	audio_player.play()
