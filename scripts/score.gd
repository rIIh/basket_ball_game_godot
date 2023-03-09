extends Node

var sessions: Array

var current_session: Session:
	get:
		return sessions.back()
		
func _ready():
	print('loading')
	sessions = load_game()
	print('loaded ', sessions)


func increment(has_collisions: bool):
	current_session.increment(1 if has_collisions else 2)
	Events.dispatch(ScoreChanged.increment(current_session.score))

	save_game()

func reset():
	current_session.complete()
	sessions.append(Session.zero())
	Events.dispatch(ScoreChanged.reset())
	
	save_game()

## Save/Load

const _save_game_path := "user://user_1"
const _save_game_name := "sessions.json"

func save_game():
	if not DirAccess.dir_exists_absolute(_save_game_path):
		DirAccess.make_dir_recursive_absolute(_save_game_path)
		
	var save_game = FileAccess.open(_save_game_path + "/" + _save_game_name, FileAccess.WRITE)
	
	var sessions_json = JSON.stringify(sessions.map(func(session: Session): return session.to_json()))
	
	save_game.store_line(sessions_json)
	

func load_game():
	if not FileAccess.file_exists(_save_game_path):
		print('zeroed')
		return [Session.zero()]

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open(_save_game_path, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return [Session.zero()]

		# Get the data from the JSON object
		var save_data: Array = json.get_data()
		
		return save_data.map(func(json: Dictionary): return (json))

