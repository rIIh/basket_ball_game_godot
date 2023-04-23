extends Node

@onready
var _repository: SessionRepository = SessionProvider.repository

var session: Session
var score: int :
	get: return session.score

func _ready():
	session = _repository.get_last_session_or_new()


func increment(addendum: int):
	var prev_score = session.score
	
	session.increment(addendum)
	_repository.update_session(session)
	Events.dispatch(ScoreChanged.increment(prev_score, session.score))

func reset():
	var prev_score = session.score
	session.complete()
	_repository.update_session(session)
	
	session = _repository.create_session()
	
	Events.dispatch(ScoreChanged.reset(prev_score))
	
