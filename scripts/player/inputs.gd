# This script is used to handle inputs 

extends Node # static class

# Define custom signals
signal move_input(direction: Vector2)
signal jump_pressed()

# Built-in functions
# Handle player input
func _process(_delta):
    # Declare a variable to store the input direction
    var direction = Input.get_axis("Left", "Right")

    # Fire the move_input signal
    emit_signal("move_input", direction)

    # Check if the jump button was just pressed
    if Input.is_action_just_pressed("Jump"):
        emit_signal("jump_pressed") # Fire the jump_pressed signal
