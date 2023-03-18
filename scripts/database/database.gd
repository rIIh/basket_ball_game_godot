extends Object

class_name Database

const verbosity_level : int = SQLite.VERBOSE

var _sqlite = preload("res://addons/godot-sqlite/godot-sqlite.gd")
var _connection : SQLite = null

var _in_memory = not (OS.get_name() in ["iOS", "Android", "Windows", "macOS", "Linux"])

var _database_folder := "user://user_0"
var _database_name := "database"
var _database_path := ":memory:" if _in_memory else (_database_folder + "/" + _database_name)

var sessions: SessionTable

func _init():
	DirAccess.make_dir_recursive_absolute(_database_folder)
	
	_connection = SQLite.new()
	_connection.path = _database_path
	_connection.verbosity_level = verbosity_level
	
	_connection.open_db()
	
	sessions = SessionTable.new(_connection)

