extends Node

var _repository: SessionRepository
var repository: SessionRepository : 
	get:
		return _repository

func _ready():
	_repository = FileSessionRepository.new()
#	_repository = SQLiteSessionRepository.new(DatabaseProvider.database.sessions)
