extends CharacterBody2D

# Signals for input events
signal move_input(direction: float)
signal jump_pressed()

# Constants
@export var speed := 400 # Horizontal speed
@export var jump_force := 600 # Jump impulse
@export var gravity := 30 # Gravity per frame
@export var max_jumps := 2 # Max jumps (double jump)
@export var double_jump := false # Enable double jump

# Variables
var jumps_left := max_jumps # Remaining jumps

# Resources
var jump_sound = preload("res://assets/audio/sfx/jump.wav")
var audio_player: AudioStreamPlayer

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var trails = $ParticleTrails

# Built-in functions
# Called when the node enters the scene tree for the first time
func _ready():
	# Setup audio player for jump sound
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = jump_sound
	audio_player.bus = "sfx"
	add_child(audio_player)

# Called every frame
func _process(_delta):
	# Process input every frame
	var dir = Input.get_axis("Left", "Right") # Horizontal input (-1..1)
	emit_signal("move_input", dir)
	if Input.is_action_just_pressed("Jump"):
		emit_signal("jump_pressed")
	
	# Apply physics and move player
	_apply_gravity()
	_move(dir)
	_update_animation()
	sprite.flip_h = velocity.x < 0

# Internal functions
# Apply gravity
func _apply_gravity():
	# Gravity and jump reset on floor
	if is_on_floor():
		jumps_left = max_jumps
	else:
		velocity.y += gravity

# Move player
func _move(direction: float):
	# Set horizontal velocity and move
	velocity.x = direction * speed
	move_and_slide()

# Try to jump
func try_jump():
	# Handle jumping logic
	if is_on_floor() and not double_jump:
		_perform_jump()
	elif double_jump and jumps_left > 0:
		_perform_jump()
		jumps_left -= 1

# Perform jump
func _perform_jump():
	# Jump impulse and sound
	velocity.y = - jump_force
	audio_player.play()

# Update animation
func _update_animation():
	# Manage animations and particle trails
	trails.emitting = false
	if is_on_floor():
		if abs(velocity.x) > 0:
			trails.emitting = true
			sprite.play("Walk", 1.5)
		else:
			sprite.play("Idle")
	else:
		sprite.play("Jump")

# External functions
# Connect input signals to internal jump method
func _on_jump_pressed():
	try_jump()
