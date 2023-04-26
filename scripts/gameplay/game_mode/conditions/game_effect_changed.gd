extends GameCondition

class_name GameEffectChanged

enum ChangeType {
	ENTERED = 1 << 0,
	EXITED = 1 << 1,
	CHANGED = 1 << 3,
}

@export
var target: GameEffect

@export_flags("Entered", "Exited", "Changed")
var triggers: int

func _ready():
	super._ready()
	
	game_mode.on_effect_entered.connect(func(effect): trigger() if triggers & ChangeType.ENTERED and effect == target else null)
	game_mode.on_effect_exited.connect(func(effect): trigger() if triggers & ChangeType.EXITED and effect == target else null)
	game_mode.on_effect_changed.connect(func(effect): trigger() if triggers & ChangeType.CHANGED and effect == target else null)
