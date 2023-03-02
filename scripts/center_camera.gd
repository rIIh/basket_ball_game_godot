extends Camera2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport = get_viewport_rect()
	print(viewport.size)
	#offset = viewport.size / 2;
