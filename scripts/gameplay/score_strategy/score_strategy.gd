@tool
extends Resource

class_name ScoreStrategy

var ball_spawner: BallSpawner

func check_should_enter(active_strategy: ScoreStrategy) -> bool:
	return false
	
func start():
	pass

func enter(from: ScoreStrategy = null):
	pass

#func handle_ball_spawned(ball: BallBody, state: Session) -> StrategyDesire:
#	return StrategyDesire.NONE
#
#func handle_ball_launched(ball: BallBody, state: Session) -> StrategyDesire:
#	return StrategyDesire.NONE
	
func handle_ball_dropped(ball: BallBody, state: Session) -> StrategyDesire.Values:
	return StrategyDesire.NONE
	
func handle_ball_destroyed(ball: BallBody, state: Session) -> StrategyDesire.Values:
	return StrategyDesire.NONE

func exit(to: ScoreStrategy):
	pass

# Editor tools

func get_title():
	return "ScoreStrategy"
