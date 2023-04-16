@tool
extends BoxContainer

class_name FractionalOffset

@export
var translation: Vector2 = Vector2.ZERO

@export
var clip_content = true

func _ready():
	if clip_content == null:
		clip_content = true
		
	clip_contents = clip_content;

func _process(delta):
	if not get_children().size():
		return;
		
	var child: Control = get_child(0);
	var size = child.size;
	
	child.set_position(size * translation)
	
	clip_contents = clip_content;
 
