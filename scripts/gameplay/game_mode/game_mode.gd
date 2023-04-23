@tool
extends Resource

class_name GameMode

signal on_ball_spawned(ball: BallBody)
signal on_ball_dropped(ball: BallBody)
signal on_ball_destroyed(ball: BallBody)

signal on_strategy_exit(strategy: ScoreStrategy)
signal on_strategy_enter(strategy: ScoreStrategy)

signal on_complete

# Dependencies

var ball_spawner: BallSpawner :
	set(value):
		if value != ball_spawner:
			if ball_spawner:
				ball_spawner.on_ball_spawned.disconnect(_broadcast_ball_spawned)
			if value:
				value.on_ball_spawned.connect(_broadcast_ball_spawned)
				
		ball_spawner = value

func _broadcast_ball_spawned(ball: BallBody):
#	ball.ball_pushed.connect(func(): handle_ball_launched(ball))
	ball.ball_dropped.connect(func(): handle_ball_dropped(ball))
	on_ball_spawned.emit(ball)

# State

var _previous_strategy: ScoreStrategy
var _active_strategy: ScoreStrategy


# Game events

func start():
	for strategy in _strategies:
		strategy.ball_spawner = ball_spawner
		
	_active_strategy = _get_initial_strategy()
	_active_strategy.start()

#func handle_ball_spawned(ball: BallBody):
#	var strategy = _active_strategy
#	var desire = strategy.handle_ball_spawned(ball, Score.session)
#	_handle_desire(strategy, desire)
	
#func handle_ball_launched(ball: BallBody):
#	var strategy = _active_strategy
#	var desire = strategy.handle_ball_launched(ball, Score.session)
#	_handle_desire(strategy, desire)
	
func handle_ball_dropped(ball: BallBody):
	var strategy = _active_strategy
	var desire = strategy.handle_ball_dropped(ball, Score.session)
	_handle_desire(strategy, desire)
	
func handle_ball_destroyed(ball: BallBody):
	var strategy = _active_strategy
	var desire = strategy.handle_ball_destroyed(ball, Score.session)
	_handle_desire(strategy, desire)

func _handle_desire(strategy, desire: int):
	if _active_strategy != strategy:
		return

	match(desire):
		StrategyDesire.Values.BREAK:
			var expectant = links_break.get_connected_strategies(strategy)[0]
			_goto(expectant)
		StrategyDesire.Values.NEXT:
			var expectant = links_next.get_connected_strategies(strategy)[0]
			_goto(expectant)
		StrategyDesire.Values.PREVIOUS:
			_goto(_previous_strategy)
		StrategyDesire.Values.COMPLETE:
			_goto(_get_initial_strategy())
			on_complete.emit()
		StrategyDesire.Values.NONE:
			var expectants = links_check.get_connected_strategies(strategy)
			for expectant in expectants:
				if expectant.check_should_enter(strategy):
					_goto(expectant)
					break


# Game tools

func _get_initial_strategy() -> ScoreStrategy:
	if Engine.is_editor_hint():
		return null
		
	for strategy in _strategies:
		var check = func(links: Array[ScoreStrategy]): 
			return strategy in links
		
		var enter_connected: bool = links_next.links.any(check) || links_break.links.any(check) || links_check.links.any(check)
		if enter_connected:
			continue
		else:
			return strategy
			
	return _strategies[0]

func _goto(strategy: ScoreStrategy):
	if Engine.is_editor_hint():
		return

	if not strategy:
		return

	_previous_strategy = _active_strategy
	if _active_strategy:
		_active_strategy.exit(strategy)
		on_strategy_exit.emit(_active_strategy)
		
	_active_strategy = strategy
	_active_strategy.enter(_previous_strategy)
	on_strategy_enter.emit(_active_strategy)

func reset():
	_goto(_get_initial_strategy())


# Configuration

@export
var _strategies: Array[ScoreStrategy] = []

@export
var links_next := StrategyLinks.new()

@export
var links_break := StrategyLinks.new()

@export
var links_check := StrategyLinks.new()


# Editor tools

func get_strategies() -> Array[ScoreStrategy]:
	return _strategies


func add_strategy(strategy: ScoreStrategy):
	if strategy and not strategy in _strategies:
		_strategies.append(strategy)


func _clear():
	_strategies.clear()
	links_next.clear()
	links_break.clear()
	links_check.clear()
