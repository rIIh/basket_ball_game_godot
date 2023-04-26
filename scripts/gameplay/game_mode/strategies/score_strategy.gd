extends GameModeStrategy

class_name ScoreStrategyNext

func _ready():
	super._ready()
	
	game_mode.on_ball_dropped.connect(_execute)

func _execute(ball: BallBody):
	var modifiers = _get_score_modifiers()
	var initial_delta = 2 if ball.collisions == 0 else 1
	var result_delta = modifiers.reduce(func(acc: int, mod: ScoreModifier): return mod.apply(acc), initial_delta)
	
	game_mode.increment_score(result_delta)


func _get_score_modifiers():
	var modifiers: Array[ScoreModifier] = []
	for modifier in game_mode.active_effects:
		if modifier is ScoreModifier:
			modifiers.append(modifier)
			
	return modifiers
