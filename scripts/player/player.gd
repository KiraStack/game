extends Node

# Node references
@onready var physics = $Physics
@onready var inputs = $Inputs
@onready var sprite = $AnimatedSprite2D
@onready var trails = $ParticleTrails

func _ready():
    # Connect input signals to handlers
    inputs.connect("move_input", Callable(self, "_on_move_input"))
    inputs.connect("jump_pressed", Callable(self, "_on_jump_pressed"))

func _process(_delta):
    # Apply gravity and default movement
    physics.apply_gravity()
    physics.move_player(0)
    
    # Update animation and effects
    _animate()
    
    # Flip sprite based on movement direction
    sprite.flip_h = physics.velocity.x < 0

func _on_move_input(dir):
    # Handle horizontal movement input
    physics.move(dir)

func _on_jump_pressed():
    # Handle jump input
    physics.try_jump()

func _animate():
    # Disable particle trails by default
    trails.emitting = false
    
    if physics.is_on_floor():
        if abs(physics.velocity.x) > 0:
            # Emit trails and play walk animation when moving on ground
            trails.emitting = true
            sprite.play("Walk", 1.5)
        else:
            # Play idle animation when stationary
            sprite.play("Idle")
    else:
        # Play jump animation when airborne
        sprite.play("Jump")
