@tool
extends Node

class_name GameMode

signal on_ball_spawned(ball: BallBody)
signal on_ball_dropped(ball: BallBody)
signal on_ball_destroyed(ball: BallBody)

signal on_strategy_exit(strategy: ScoreStrategy)
signal on_strategy_enter(strategy: ScoreStrategy)

signal on_complete

# Configuration

@export
var links_next := StrategyLinks.new()

@export
var links_break := StrategyLinks.new()

@export
var links_check := StrategyLinks.new()

func get_strategies() -> Array[ScoreStrategy]:
	var strategies: Array[ScoreStrategy] = []
	for child in get_children():
		if child is ScoreStrategy:
			strategies.append(child)

	return strategies

func get_strategy(index: int) -> ScoreStrategy:
	return get_strategies()[index]

# State

var _previous_strategy: ScoreStrategy
var _active_strategy: ScoreStrategy
var active: bool = false


# Godot Lifecycle

@export
var ball_spawner: BallSpawner


func _ready():
	if not Engine.is_editor_hint():
		ball_spawner.on_ball_spawned.connect(_broadcast_ball_spawned)
	
	for child in get_children():
		if child is ScoreStrategy:
			child.game_mode = self
	
func _broadcast_ball_spawned(ball: BallBody):
	if active:
	#	ball.ball_pushed.connect(func(): handle_ball_launched(ball))
		ball.ball_dropped.connect(func(): handle_ball_dropped(ball))
		on_ball_spawned.emit(ball)


# Game events

func start():
	active = true
	var initial_strategy = _get_initial_strategy()
	if active and _active_strategy:
		_active_strategy.exit(initial_strategy)
			
	_active_strategy = initial_strategy
	_active_strategy.start()

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
			var expectant_index = links_break.get_connected_strategies(
				get_strategy_index(strategy)
			)[0]
			var expectant = get_strategy(expectant_index)
			_goto(expectant)
		StrategyDesire.Values.NEXT:
			var expectant_index = links_next.get_connected_strategies(
				get_strategy_index(strategy)
			)[0]
			var expectant = get_strategy(expectant_index)
			_goto(expectant)
		StrategyDesire.Values.PREVIOUS:
			_goto(_previous_strategy)
		StrategyDesire.Values.COMPLETE:
			_goto(_get_initial_strategy())
			on_complete.emit()
		StrategyDesire.Values.NONE:
			var expectants = links_check.get_connected_strategies(
				get_strategy_index(strategy)
			)
			for expectant_index in expectants:
				var expectant = get_strategy(expectant_index)
				if expectant.check_should_enter(strategy):
					_goto(expectant)
					break


func get_strategy_index(strategy: ScoreStrategy):
	var index = 0
	for r_strategy in get_strategies():
		if strategy == r_strategy:
			return index
		index += 1
		
	return -1

# Game tools

func _get_initial_strategy() -> ScoreStrategy:
	if Engine.is_editor_hint():
		return null
		
	var strategies = get_strategies()
	for strategy in strategies:
		var check = func(links: Array[ScoreStrategy]): 
			return strategy in links
		
		var enter_connected: bool = links_next.links.any(check) || links_break.links.any(check) || links_check.links.any(check)
		if enter_connected:
			continue
		else:
			return strategy
			
	return strategies[0]

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


# Editor tools

func add_strategy(strategy: ScoreStrategy):
	if strategy and not strategy in get_strategies():
		if strategy.is_inside_tree():
			add_child(strategy.duplicate())
		else:
			add_child(strategy)


func _clear_connections():
	links_next.clear()
	links_break.clear()
	links_check.clear()
