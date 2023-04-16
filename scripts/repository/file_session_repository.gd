extends SessionRepository

class_name FileSessionRepository

var last_session: Session
var best_session: Session

var _last_session_file_name = 'last_session'
var _best_session_file_name = 'best_session'

static func _get_base_path():
	return "saves/user_01"

static func _get_file_path(filename: String):
	return "user://%s/%s" % [_get_base_path(), filename]

func _init():
	last_session = _read(_last_session_file_name)
	best_session = _read(_best_session_file_name)


func get_best_session() -> Session:
	if not best_session or last_session and last_session.score > best_session.score:
		return last_session
		
	return best_session if best_session else last_session


func get_last_session() -> Session:
	return last_session


func create_session() -> Session:
	if last_session and best_session and last_session.score > best_session.score or last_session and not best_session:
		_write(_best_session_file_name, last_session)
		best_session = last_session
		
	var next_id = last_session.id + 1 if last_session else 0
	last_session = Session.zero(next_id)
	_write(_last_session_file_name, last_session)
	
	return last_session


func get_last_session_or_new() -> Session:
	if not last_session:
		return create_session()
		
	return last_session


func update_session(session: Session) -> void:
	session._updated_at = Session.get_time()
	_write(_last_session_file_name, session)
	

func _write(filename: String, session: Session):
	DirAccess.open("user://").make_dir_recursive(_get_base_path())
	var path = _get_file_path(filename)	
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var({
		"id": session.id,
		"score": session.score,
		"state": session._state,
		"started_at": session._started_at,
		"updated_at": session._updated_at,
	})

func _read(filename: String):
	var path = _get_file_path(filename)
	
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var dictionary: Dictionary = file.get_var(true)
		return Session.new(
			dictionary["id"],
			dictionary["score"],
			dictionary["state"],
			dictionary["started_at"],
			dictionary["updated_at"],
		)
