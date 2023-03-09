extends Node

var _sqlite = preload("res://addons/godot-sqlite/godot-sqlite.gd")

var db : SQLite = null

const verbosity_level : int = SQLite.VERBOSE

var in_memory = not (OS.get_name() in ["iOS", "Android", "Windows", "macOS", "Linux"])

var database_folder := "user://user_0"
var database_name := "database"
var sessions_table = "sessions"

var database_path := ":memory:" if in_memory else (database_folder + "/" + database_name)

func _ready():
	print("Opening database %s" % database_name)
	
	DirAccess.make_dir_recursive_absolute(database_name)
	
	db = SQLite.new()
	db.path = database_name
	db.verbosity_level = verbosity_level
	
	db.open_db()
	_prepare_sessions()

func _prepare_sessions():
	var table_dict : Dictionary = Dictionary()
	
	table_dict["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
	table_dict["score"] = {"data_type":"int", "not_null": true}
	
	table_dict["started_at"] = {"data_type":"text", "not_null": true}
	table_dict["updated_at"] = {"data_type":"text", "not_null": false}
	table_dict["completed_at"] = {"data_type":"text", "not_null": false}
	
	if Engine.is_editor_hint():
		db.drop_table(sessions_table)

	db.create_table(sessions_table, table_dict)
	
func get_time(): 
	return Time.get_datetime_string_from_system(true, true)

func get_last_session():
	db.query("SELECT id, score, completed_at FROM %s ORDER BY id DESC LIMIT 1;" % sessions_table)
	if db.query_result:
		var id = db.query_result[0]["id"]
		var score = db.query_result[0]["score"]
		var completed = db.query_result[0]["completed_at"]
		
		return Session.new(id, score, Session.State.completed if completed else Session.State.running)

	return null

func create_session():
	var time = get_time()
	db.query("SELECT id, completed_at FROM %s ORDER BY id DESC LIMIT 1;" % sessions_table)
	var result = db.query_result
	
	
	var id = 0
	if result:
		var last_id = result[0]["id"]
		id = last_id + 1
		
		if result[0]["completed_at"] == null:
			push_error("Previous session(%s) is not completed" % last_id)
		
	db.insert_row(sessions_table, {"id": id, "score": 0, "started_at": time})
	return Session.zero(id)

func get_last_session_or_new():
	var last: Session = get_last_session()
	if not last or last.is_completed:
		return create_session()
		
	return last

func update_session(session: Session):
	var time = get_time()
	var update_payload = {
		"SCORE": session.score,
		"UPDATED_AT": time,
		"COMPLETED_AT": time if session.is_completed else null,
	}
	
	db.update_rows(sessions_table, "id = '%s'" % session.id, update_payload)
	
