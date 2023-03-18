extends Node

var _repository: SessionRepository
var repository: SessionRepository : 
	get:
		return _repository

func _ready():
	match OS.get_name():
		"Windows", "UWP", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			_repository = SQLiteSessionRepository.new(DatabaseProvider.database.sessions)
		"Android", "iOS":
			_repository = JSONSessionRepository.new()
		"Web":
			print("Web")
