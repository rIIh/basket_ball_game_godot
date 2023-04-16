extends Node2D

@onready
var ball_spawner : BallSpawner = $BallSpawner

var dropped := false;

var game_state: int = GameState.initial : 
	set(value):
		if game_state != value:
			Events.dispatch(GameStateChanged.new(game_state, value))
			game_state = value
			

func _ready():
	_respawn(true)
	

func _on_out_area_body_entered(body):
	body.queue_free()
	_respawn();

func _respawn(first_pass: bool = false):
	var ball: BallBody = ball_spawner.spawn(randf_range(-1, 1))
	ball.ball_interacted.connect(func(): game_state = GameState.playing)
	
#   Many balls chain spawn
#   to make to work remove _respawn() in out area trigger
#	ball.ball_pushed.connect(
#		func(): 
#			await get_tree().create_timer(.35).timeout
#			_respawn(true)
#
#	)
	
	if not dropped and not first_pass:
		game_state = GameState.finished
		Score.reset()
		
	dropped = false
	

func _on_basket_enable_area_entered(body):
	if body is BallBody:
		body.is_collisions_enabled = true
		body.z_index = 5

func _on_floor_area_exited(body: Node2D):
	body.z_index = 8

func _on_basket_on_ball_dropped(collisions):
	Score.increment(collisions > 0)
	dropped = true;
