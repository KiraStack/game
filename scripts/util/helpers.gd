# Define static helper functions

extends Node # static class

# Returns a value between a and b based on t (0 to 1).
static func lerp(a: float, b: float, t: float) -> float:
    return a + (b - a) * t

# Limits value to stay between min_val and max_val.
static func clamp(value: float, min_val: float, max_val: float) -> float:
    return max(min_val, min(value, max_val))

# Picks a random item from array or returns null if empty.
static func random_choice(array: Array) -> Variant:
    if array.size() == 0:
        return null
    return array[randi() % array.size()]
