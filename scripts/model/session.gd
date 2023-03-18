extends Object

class_name Session

enum State {
	running,
	completed
}



var _id: int;
var _score := 0
var _state: State

var id: int:
	get: return _id;

var score:
	get: return _score

var is_completed:
	get: return _state == Session.State.completed


func _init(id: int, score: int, state: State):
	self._id = id
	self._score = score
	self._state = state


static func zero(id: int): return Session.new(id, 0, State.running)

func increment(delta: int):
	if _state == Session.State.running:
		_score += delta

func complete():
	_state = State.completed

