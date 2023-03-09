extends Node

var session: Session

func _ready():
	session = Database.get_last_session_or_new()


func increment(has_collisions: bool):
	session.increment(1 if has_collisions else 2)
	Database.update_session(session)
	Events.dispatch(ScoreChanged.increment(session.score))

func reset():
	session.complete()
	Database.update_session(session)
	session = Database.create_session()
	
	Events.dispatch(ScoreChanged.reset())
	

