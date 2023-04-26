extends Node

class_name GameModeDescendant

var game_mode: GameModeNext
var has_conditions: bool # todo: bad pattern?

func _ready():
	game_mode = _find_game_mode()


func _find_game_mode(node: Node = self) -> GameModeNext:
	if node is GameCondition:
		has_conditions = true

	if node == null:
		push_error("Failed to find game mode in ancestors")
		return null
	
	if node is GameModeNext:
		return node
	
	return _find_game_mode(node.get_parent())

