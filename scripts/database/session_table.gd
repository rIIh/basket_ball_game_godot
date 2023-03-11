extends Object

class_name SessionTable

const table = "sessions"

var _connection: SQLite;

func _init(connection: SQLite):
	self._connection = connection
	_create_if_not_exists()

func get_structure() -> Dictionary:
	var table_structure : Dictionary = Dictionary()
	
	table_structure["id"] 			= 	{"data_type":"int", "primary_key": true, "not_null": true}
	table_structure["score"] 		= 	{"data_type":"int", "not_null": true}
	
	table_structure["started_at"] 	= 	{"data_type":"text", "not_null": true}
	table_structure["updated_at"] 	= 	{"data_type":"text", "not_null": false}
	table_structure["completed_at"] = 	{"data_type":"text", "not_null": false}
	
	return table_structure

func _create_if_not_exists() -> void:
	if Engine.is_editor_hint():
		_connection.drop_table(table)

	_connection.create_table(table, get_structure())

func get_last_session() -> Session:
	_connection.query("SELECT id, score, completed_at FROM %s ORDER BY id DESC LIMIT 1;" % table)
	if _connection.query_result:
		var id = _connection.query_result[0]["id"]
		var score = _connection.query_result[0]["score"]
		var completed = _connection.query_result[0]["completed_at"]
		
		return Session.new(id, score, Session.State.completed if completed else Session.State.running)

	return null

func get_time() -> String:
	return Time.get_datetime_string_from_system(true, true)


func create_session() -> Session:
	var time = get_time()
	_connection.query("SELECT id, completed_at FROM %s ORDER BY id DESC LIMIT 1;" % table)
	var result = _connection.query_result
	
	
	var id = 0
	if result:
		var last_id = result[0]["id"]
		id = last_id + 1
		
		if result[0]["completed_at"] == null:
			push_error("Previous session(%s) is not completed" % last_id)
		
	_connection.insert_row(table, {"id": id, "score": 0, "started_at": time})
	return Session.zero(id)

func get_last_session_or_new() -> Session:
	var last: Session = get_last_session()
	if not last or last.is_completed:
		return create_session()
		
	return last

func update_session(session: Session) -> void:
	var time = get_time()
	var update_payload = {
		"SCORE": session.score,
		"UPDATED_AT": time,
		"COMPLETED_AT": time if session.is_completed else null,
	}
	
	_connection.update_rows(table, "id = '%s'" % session.id, update_payload)
	
