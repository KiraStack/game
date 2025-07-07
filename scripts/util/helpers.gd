extends Node

static func lerp(a: float, b: float, t: float) -> float:
	return a + (b - a) * t

static func clamp(value: float, min_val: float, max_val: float) -> float:
	return max(min_val, min(value, max_val))

static func random_choice(array: Array) -> Variant:
	if array.empty():
		return null
	return array[randi() % array.size()]
