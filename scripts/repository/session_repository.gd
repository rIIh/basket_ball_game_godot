extends Object

class_name SessionRepository

func get_time() -> String:
	return Time.get_datetime_string_from_system(true, true)

func get_best_session() -> Session:
	push_error("not implemented")
	return null


func get_last_session() -> Session:
	push_error("not implemented")
	return null


func create_session() -> Session:
	push_error("not implemented")
	return null


func get_last_session_or_new() -> Session:
	push_error("not implemented")
	return null


func update_session(session: Session) -> void:
	push_error("not implemented")
