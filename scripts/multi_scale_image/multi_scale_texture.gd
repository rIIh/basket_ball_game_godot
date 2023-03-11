@tool
extends Resource

class_name MultiScaleTexture

@export var asset_name: String

@export
var dictionary: Dictionary

# Notice the setter method.
@export var scan_assets = false :
	set = do_scan_assets

func get_texture(scale: int):
	if dictionary.is_empty():
		push_error("Invalid resource state. No Assets are assigned")
	
	var file = dictionary.get(scale, dictionary.values()[0])
	if file != null:
		return load(_join([_get_resource_folder(), file], "/"))

func _get_resource_folder() -> String:
	var path = resource_path
	var folder = _join(path.split("/").slice(0, -1), "/")
	
	return folder

# In GDScript, setters always need to accept at least one parameter.
# To make it easier to call this method from code, you can make the parameter optional
# by giving it a default value.
func do_scan_assets(value = null):
	if not Engine.is_editor_hint():
		return

	dictionary.clear()
	
	var path = resource_path
	var folder = _join(path.split("/").slice(0, -1), "/")
	var files = DirAccess.get_files_at(folder)
	
	for file in files:
		var filename = file.get_basename();
		print(filename)
		if asset_name in filename and not ".import" in file:
			var scale = filename.split(".")[0].replace(asset_name, "")
			if scale.is_empty():
				dictionary[1] = file
			else:
				var num_scale = int(scale)
				dictionary[num_scale] = file
			

func _join(strings: Array, delimeter: String) -> String:
	var result = ""
	var index = 0
	for string in strings:
		result += string
		if not index + 1 == strings.size():
			result += delimeter
		index += 1
	
	return result
