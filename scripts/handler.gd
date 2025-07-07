extends Node

# Constants
const path = "res://scripts" # Root scripts directory to scan
const exclude = ["services", "util"] # Folders to ignore during traversal

# Built-in functions
func _ready():
	# Entry point when the node is added to the scene
	print("Scanning script directory.")
	process_dir(path)
	print("Scan complete.")

# Recursively process a directory and its subdirectories
func process_dir(directory: String) -> void:
	# Open the directory
	var dir = DirAccess.open(directory)
	if dir == null:
		push_error("Failed to open directory: " + directory)
		return

	# Begin reading the directory contents
	dir.list_dir_begin()
	var file_name = dir.get_next()

	# Iterate over each item in the directory
	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				# Skip excluded top-level folders
				if directory == path and file_name in exclude:
					file_name = dir.get_next()
					continue

				# Recurse into subdirectory
				process_dir(directory + "/" + file_name)
		else:
			# Process valid GDScript files, except "main.gd"
			if file_name.ends_with(".gd") and file_name != "main.gd":
				var full_path = directory + "/" + file_name

				# Attempt to load the script resource at runtime
				var script = load(full_path)

				# Check if the resource is a valid GDScript
				if script is GDScript:
					# Successfully loaded a GDScript file
					print("Loaded script:", full_path)

					# Create a new instance of a generic Node with the script attached
					var instance = Node.new()
					instance.set_script(script)
					instance.name = file_name.get_basename()

					# Add the new node to the current handler as a child
					add_child(instance)

					# Manually call 'ready' if defined
					if instance.has_method("_ready"):
						instance._ready()
				else:
					# Warn if the resource is not a valid GDScript
					push_warning("Non-GDScript file encountered: " + full_path)

		file_name = dir.get_next()

	dir.list_dir_end()
