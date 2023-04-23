@tool
extends Resource

class_name StrategyLinks

@export
var _links: Dictionary

var links: Array : 
	get:
		return _links.values()

func _init(initial_links: Dictionary = {}):
	_links = initial_links

func get_connected_strategies(for_strategy: ScoreStrategy) -> Array[ScoreStrategy]:
	if not _links.has(for_strategy):
		_links[for_strategy] = [] as Array[ScoreStrategy]
		
	return _links.get(for_strategy)


func add_connection(for_strategy: ScoreStrategy, to_strategy: ScoreStrategy):
	var links = get_connected_strategies(for_strategy)
	if not to_strategy in links:
		get_connected_strategies(for_strategy).append(to_strategy)


func remove_connection(for_strategy: ScoreStrategy, to_strategy: ScoreStrategy):
	get_connected_strategies(for_strategy).erase(to_strategy)


func clear():
	_links.clear()
