extends Camera2D


func _process(delta):
	var viewport = get_viewport_rect()
	position = Vector2((390 - viewport.size.x) / 2, (844 - viewport.size.y) / 2)
