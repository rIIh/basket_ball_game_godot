extends GameModeStrategy

class_name GameCompleteStrategy

func _ready():
	super._ready()
	
	game_mode.on_ball_destroyed.connect(_handle_destroyed)

func _handle_destroyed(ball: BallBody):
	if not ball.dropped:
		game_mode.complete()
