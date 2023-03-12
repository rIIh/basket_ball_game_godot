extends Node

var session: Session

func _ready():
	session = Database.sessions.get_last_session_or_new()


func increment(has_collisions: bool):
	var prev_score = session.score
	session.increment(1 if has_collisions else 2)
	Database.sessions.update_session(session)
	Events.dispatch(ScoreChanged.increment(prev_score, session.score))

func reset():
	var prev_score = session.score
	session.complete()
	Database.sessions.update_session(session)
	session = Database.sessions.create_session()
	
	Events.dispatch(ScoreChanged.reset(prev_score))
	

