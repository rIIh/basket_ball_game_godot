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

func get_connected_strategies(index: int) -> Array[int]:
	if not _links.has(index):
		_links[index] = [] as Array[int]
		
	return _links.get(index)


func add_connection(for_index: int, to_index: int):
	var links = get_connected_strategies(for_index)
	if not to_index in links:
		get_connected_strategies(for_index).append(to_index)


func remove_connection(for_index: int, to_index: int):
	get_connected_strategies(for_index).erase(to_index)


func clear():
	_links.clear()
