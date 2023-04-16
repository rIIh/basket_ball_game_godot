extends Control

var _tween: Tween
func _ready():
	_tween = create_tween().set_loops().set_parallel(true)
	for child in get_children():
		var fo = _get_frac_offset(child)
		if fo != null:
			_tween.tween_property(fo, 'translation', Vector2(0, -1), 1)
	
	_tween.chain().tween_callback(_jump_to_start)
			
	_tween.play()

func _jump_to_start():
	for child in get_children():
		var fo = _get_frac_offset(child)
		if fo != null:
			fo.translation = Vector2.ZERO

func _get_frac_offset(node: Node) -> FractionalOffset:
	if node is FractionalOffset:
		return node
		
	var child = node.get_child(0)
	if child:
		return _get_frac_offset(child)
	
	return null
