extends GameModifier

class_name ScoreModifier

@export 
var multiplicator: int

func apply(score: int) -> int:
	return score * multiplicator
