@tool
extends ScoreStrategy

class_name BasicScoreStrategy


func register(mode: GameMode) -> ScoreStrategy:
	return self

func start():
	ball_spawner.spawn(randf_range(-1, 1))
	

func handle_ball_dropped(ball: BallBody, state: Session) -> StrategyDesire.Values:
	Score.increment(1 if ball.collisions > 0 else 2)
	return StrategyDesire.NONE

func handle_ball_destroyed(ball: BallBody, state: Session) -> StrategyDesire.Values:
	ball_spawner.spawn(randf_range(-1, 1))

	if not ball.dropped:
		return StrategyDesire.COMPLETE

	return StrategyDesire.NONE
	

func get_title():
	return "BasicScoreStrategy"
