extends Resource
class_name GameObject

enum Colors {ORANGE, RED, BLUE, GREEN}

@export var my_color : Colors
@export var texture_options : Array[CompressedTexture2D]

func get_my_color_texture() -> CompressedTexture2D:
	# Load Godot icon to not break if not found
	var color_matching_texture : CompressedTexture2D = load("res://icon.svg")
	
	for texture in texture_options:
		if texture.resource_path.contains(get_my_color_as_string()):
			color_matching_texture = texture
			break
		
	return color_matching_texture
	
func get_my_color_as_string() -> String:
	return Colors.keys()[my_color].to_lower()
