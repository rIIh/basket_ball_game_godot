extends Node

var current_score := 0
var max_score := 0

func increment(has_collisions: bool):
	current_score += 2 if has_collisions else 1
	Events.dispatch(ScoreChanged.increment(current_score))


func reset():
	current_score = 0
	Events.dispatch(ScoreChanged.reset())
