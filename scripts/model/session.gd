extends Object

class_name Session

static func get_time() -> String:
	return Time.get_datetime_string_from_system(true, true)

enum State {
	running,
	completed
}

var _id: int;
var _score := 0
var _state: State

var _started_at
var _updated_at

var id: int:
	get: return _id;

var score:
	get: return _score

var is_completed:
	get: return _state == Session.State.completed


func _init(id: int, score: int, state: State, started_at: String, updated_at):
	self._id = id
	self._score = score
	self._state = state
	self._started_at = started_at
	self._updated_at = updated_at


static func zero(id: int): 
	return Session.new(id, 0, State.running, get_time(), get_time())

func increment(delta: int):
	if _state == Session.State.running:
		_score += delta

func complete():
	_state = State.completed

