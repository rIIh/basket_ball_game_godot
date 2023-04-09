@tool
extends BoxContainer

class_name FractionalOffset

@export
var translation: Vector2 = Vector2.ZERO

func _ready():
	clip_contents = true;

func _process(delta):
	if not get_children().size():
		return;
		
	var child: Control = get_child(0);
	var size = child.size;
	
	child.set_position(size * translation)
 
