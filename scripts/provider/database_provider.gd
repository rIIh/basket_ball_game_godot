extends Node

var _database: Database
var database: Database : 
	get:
		return _database

func _ready():
	match OS.get_name():
		"Windows", "UWP", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			_database = Database.new()
		_:
			# TODO(melvspace): return sqlite support on ios/android when issues resolved
			_database = null
