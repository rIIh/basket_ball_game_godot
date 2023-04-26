extends GameModeStrategy

class_name SpawnStrategy

var _ball: BallBody

func _ready():
	super._ready()
	
	game_mode.on_started.connect(_handle_started)
	game_mode.on_ball_destroyed.connect(_handle_destroyed)

func spawn():
	if _ball:
		return
		
	var alignment = _compute_alignment()
	_ball = game_mode.ball_spawner.spawn(alignment)

func _handle_started():
	spawn()

func _handle_destroyed(ball: BallBody):
	_ball = null
	spawn()

func _compute_alignment() -> float:
	var modifiers = _get_alignment_modifiers()
	var modifier: SpawnAlignmentModifier = modifiers.back()
	
	if modifier:
		return modifier.range.sample(randf_range(0, 1)) * 2 - 1

	return 0

func _get_alignment_modifiers():
	var modifiers: Array[SpawnAlignmentModifier] = []
	for modifier in game_mode.active_effects:
		if modifier is SpawnAlignmentModifier:
			modifiers.append(modifier)
			
	return modifiers
