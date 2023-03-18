extends SessionRepository

class_name SQLiteSessionRepository

var _sessions: SessionTable

func _init(sessions: SessionTable):
	_sessions = sessions

func get_best_session() -> Session:
	return _sessions.get_best_session()


func get_last_session() -> Session:
	return _sessions.get_last_session()


func create_session() -> Session:
	return _sessions.create_session()


func get_last_session_or_new() -> Session:
	return _sessions.get_last_session_or_new()


func update_session(session: Session) -> void:
	return _sessions.update_session(session)
