@tool
extends BasicScoreStrategy

class_name TripleScoreStrategy

@export
var arrows_animation_speed = 1.0

@export
var modulation = 1.0

@export
var background_path: NodePath
var background: BackgroundNode :
	get: return get_local_scene().get_node(background_path)

var _drops = 0

func check_should_enter(active_strategy: ScoreStrategy) -> bool:
	return Score.score >= 1 

func enter(from: ScoreStrategy = null):
	if background:
		background.set_arrows_visible(true)
		background.tune_arrows_speed(arrows_animation_speed)

	_drops = 0
	super.enter(from)


func handle_ball_dropped(ball: BallBody, state: Session) -> StrategyDesire.Values:
	Score.increment((1 if ball.collisions > 0 else 2) * 3)
	_drops += 1
	if _drops >= 3:
		return StrategyDesire.NEXT
	
	return StrategyDesire.NONE

func exit(to: ScoreStrategy):
	if not to is TripleScoreStrategy and background:
		background.set_arrows_visible(false)

	_drops = 0
	super.exit(to)

func get_title():
	return "TripleScoreStrategy"
