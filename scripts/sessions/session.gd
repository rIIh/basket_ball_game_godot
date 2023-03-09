extends Object

class_name Session

enum State {
	running,
	completed
}

var _score := 0
var score:
	get:
		return _score

var _state: State

var is_completed:
	get: 
		return _state == Session.State.completed

func _init(score: int, state: State):
	self._score = score
	self._state = state

static func zero(): return Session.new(0, State.running)


func increment(delta: int):
	if _state == Session.State.running:
		_score += delta

func complete():
	_state = State.completed


static func from_json(json: Dictionary):
	return Session.new(json["score"], json["state"])
	
func to_json():
	return {
		"score": _score,
		"state": _state
	}
