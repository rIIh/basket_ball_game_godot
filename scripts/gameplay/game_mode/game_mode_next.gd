extends Node

class_name GameModeNext

signal on_ball_spawned(ball: BallBody)
signal on_ball_interacted(ball: BallBody)
signal on_ball_launched(ball: BallBody)
signal on_ball_dropped(ball: BallBody)
signal on_ball_destroyed(ball: BallBody)

signal on_effect_entered(effect: GameEffect)
signal on_effect_exited(effect: GameEffect)
signal on_effect_changed(effect: GameEffect)

signal on_started()
signal on_completed()

@export
var ball_spawner: BallSpawner

var active_effects: Array[GameEffect]
var is_started: bool = false

func _ready():
	ball_spawner.on_ball_spawned.connect(_handle_ball_spawned)
	
	on_effect_entered.connect(func(e): print('entered: %s' % e))
	on_effect_exited.connect(func(e): print('exited: %s' % e))
	on_effect_changed.connect(func(e): print('changed: %s' % e))
	
func start():
	if is_started: 
		return
	
	erase_active_effects()
	on_started.emit()
	is_started = true

func stop():
	if not is_started:
		return
	erase_active_effects()
	is_started = false

# todo: active effect change each other undependent of type
func activate_effect(effect: GameEffect):
	if effect in active_effects:
		return

	_battle_effects(effect)
	active_effects.append(effect)
	effect.enter()
	
	on_effect_entered.emit(effect)

func deactivate_effect(effect: GameEffect):
	if not effect in active_effects:
		return
		
	active_effects.erase(effect)
	effect.exit()
	
	on_effect_exited.emit(effect)

func erase_active_effects():
	var effects = active_effects.duplicate()
	for effect in effects:
		deactivate_effect(effect)

func increment_score(delta: int):
	Score.increment(delta)

func complete():
	on_completed.emit()


func _handle_ball_spawned(ball: BallBody):
	on_ball_spawned.emit(ball)
	ball.ball_dropped.connect(func(): on_ball_dropped.emit(ball))
	ball.ball_interacted.connect(func(): on_ball_interacted.emit(ball))
	ball.ball_pushed.connect(func(): on_ball_launched.emit(ball))

func _handle_ball_destroyed(ball: BallBody):
	on_ball_destroyed.emit(ball)

func _battle_effects(next_effect: GameEffect):
	var effects_to_remove: Array[GameEffect] = []
	for active_effect in active_effects:
		match(active_effect.battle(next_effect)):
			GameEffect.BattleResult.KEEP:
				pass
			GameEffect.BattleResult.CHANGE:
				effects_to_remove.append(active_effect)
				on_effect_changed.emit(active_effect)
			GameEffect.BattleResult.EXIT:
				effects_to_remove.append(active_effect)
				active_effect.exit()
				on_effect_exited.emit(active_effect)


	for effect_to_remove in effects_to_remove:
		active_effects.erase(effect_to_remove)

