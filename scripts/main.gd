extends Node2D

@export
var game_mode: GameModeNext

@onready
var ball_spawner : BallSpawner = $BallSpawner

var game_state: int = GameState.initial : 
	set(value):
		if game_state != value:
			Events.dispatch(GameStateChanged.new(game_state, value))
			game_state = value
			

func _ready():
	game_mode.ball_spawner = ball_spawner
	game_mode.on_ball_spawned.connect(_handle_ball_spawned)
	game_mode.on_completed.connect(_handle_completed)
	game_mode.start()


func _handle_ball_spawned(ball: BallBody):
	ball.ball_interacted.connect(_start_game_mode)
	
func _start_game_mode():
	game_state = GameState.playing
	game_mode.start()

func _handle_completed():
	game_state = GameState.finished
	game_mode.stop()
	Score.reset()
	


func _on_out_area_body_entered(body):
	if body is BallBody and game_mode:
		game_mode._handle_ball_destroyed(body)

	body.queue_free()


func _on_basket_enable_area_entered(body):
	if body is BallBody:
		body.is_collisions_enabled = true
		body.z_index = 5

func _on_floor_area_exited(body: Node2D):
	body.z_index = 8
