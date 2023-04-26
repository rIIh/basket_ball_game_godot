extends GameModeDescendant

class_name GameEffect

enum BattleResult {
	KEEP,
	EXIT,
	CHANGE,
}

@export
var battle_result: BattleResult = BattleResult.KEEP

func _ready():
	super._ready()
	
	game_mode.on_started.connect(_handle_started)

func activate():
	game_mode.activate_effect(self)

func deactivate():
	game_mode.deactivate_effect(self)

func battle(next_effect: GameEffect) -> BattleResult:
	return battle_result

func enter():
	pass
	
func exit():
	pass

func _handle_started():
	if not has_conditions:
		activate()
