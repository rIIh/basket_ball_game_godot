extends Camera2D


func _process(delta):
	var viewport = get_viewport_rect()
	position = Vector2((1170 - viewport.size.x) / 2, (2532 - viewport.size.y) / 2); 
