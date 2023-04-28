extends Node2D

@export
var game_mode: GameMode

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
	game_mode.on_complete.connect(_handle_complete)
	game_mode.start()
	
	await get_tree().create_timer(1).timeout
	$splash_screen.exit()


func _handle_ball_spawned(ball: BallBody):
	ball.ball_interacted.connect(func(): game_state = GameState.playing)
	
func _handle_complete():
	game_state = GameState.finished
	Score.reset()
	

func _on_out_area_body_entered(body):
	if body is BallBody and game_mode:
		game_mode.handle_ball_destroyed(body)

	body.queue_free()


func _on_basket_enable_area_entered(body):
	if body is BallBody:
		body.is_collisions_enabled = true
		body.z_index = 5

func _on_floor_area_exited(body: Node2D):
	body.z_index = 8
