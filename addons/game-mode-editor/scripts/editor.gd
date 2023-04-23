@tool
extends Node

@export var editor_tab_bg := StyleBoxFlat.new()
@export var strategy_node: PackedScene

@onready
var _graph: GraphEdit = $Column/GraphEdit

@onready
var _add_node_button: MenuButton = $Column/Row/AddNodeButton

var plugin_reference = null

var selected_game_mode: GameMode

var nodes := {} # strategy to node
var named_nodes := {} # node name to node

func _ready():
	_rebuild_nodes()
	_graph.connection_request.connect(_handle_connection_request)
	_graph.disconnection_request.connect(_handle_disconnection_request)
	

func can_edit_game_mode(node: GameMode):
	return true

func edit_game_mode(node: GameMode):
	selected_game_mode = node
	print(selected_game_mode)
	_rebuild_nodes()
#	_rebuild_nodes_menu()
	
func _handle_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var from_node_value = _get_node_by_name(from_node)
	var to_node_value = _get_node_by_name(to_node)
	
	
	if not from_node_value or not to_node_value:
		return
	
	var from_strategy_index = selected_game_mode.get_strategy_index(from_node_value.strategy)
	var to_strategy_index = selected_game_mode.get_strategy_index(to_node_value.strategy)
	
	match from_port:
		StrategyNode.StrategySlot.NEXT:
			_graph.connect_node(from_node, from_port, to_node, to_port)
			selected_game_mode.links_next.add_connection(from_strategy_index, to_strategy_index)
		StrategyNode.StrategySlot.BREAK:
			_graph.connect_node(from_node, from_port, to_node, to_port)
			selected_game_mode.links_break.add_connection(from_strategy_index, to_strategy_index)
		StrategyNode.StrategySlot.CHECK:
			_graph.connect_node(from_node, from_port, to_node, to_port)
			selected_game_mode.links_check.add_connection(from_strategy_index, to_strategy_index)


func _handle_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	var from_node_value = _get_node_by_name(from_node)
	var to_node_value = _get_node_by_name(to_node)
	
	if not from_node_value or not to_node_value:
		return
	
	var from_strategy_index = selected_game_mode.get_strategy_index(from_node_value.strategy)
	var to_strategy_index = selected_game_mode.get_strategy_index(to_node_value.strategy)
	
	match from_port:
		StrategyNode.StrategySlot.NEXT:
			_graph.disconnect_node(from_node, from_port, to_node, to_port)
			selected_game_mode.links_next.remove_connection(from_strategy_index, to_strategy_index)
		StrategyNode.StrategySlot.BREAK:
			_graph.disconnect_node(from_node, from_port, to_node, to_port)
			selected_game_mode.links_break.remove_connection(from_strategy_index, to_strategy_index)
		StrategyNode.StrategySlot.CHECK:
			_graph.disconnect_node(from_node, from_port, to_node, to_port)
			selected_game_mode.links_check.remove_connection(from_strategy_index, to_strategy_index)

func _get_node(strategy: ScoreStrategy) -> StrategyNode:
	return nodes[strategy]

func _get_node_by_name(name: StringName) -> StrategyNode:
	return named_nodes[name]

func _rebuild_nodes():
	nodes.clear()
	named_nodes.clear()
	_graph.clear_connections()
	for child in _graph.get_children():
		child.queue_free()
		
	if selected_game_mode:
		var strategies = selected_game_mode.get_strategies()
		for strategy in strategies:
			var node: StrategyNode = strategy_node.instantiate()
			node.title = str(strategy.get_title())
			node.size = Vector2(356, 256)
			node.strategy = strategy
			nodes[strategy] = node
			
			_graph.add_child(node)
			named_nodes[node.name] = node
			
		for strategy in strategies:
			var node = _get_node(strategy)
			var all_links = [
				[selected_game_mode.links_next, StrategyNode.StrategySlot.NEXT], 
				[selected_game_mode.links_break, StrategyNode.StrategySlot.BREAK], 
				[selected_game_mode.links_check, StrategyNode.StrategySlot.CHECK], 
			];
			
			for typed_links in all_links:
				var links: StrategyLinks = typed_links[0]
				var slot: int = typed_links[1]
				
				var linked_strategies = links.get_connected_strategies(
					selected_game_mode.get_strategy_index(strategy)
				)
				
				for to_strategy_index in linked_strategies:
					var to_strategy = selected_game_mode.get_strategy(to_strategy_index)
					var target = _get_node(to_strategy)
					_graph.connect_node(
						node.name, slot,
						target.name, StrategyNode.StrategySlot.ENTER
					)

