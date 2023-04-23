@tool
extends GraphNode

class_name StrategyNode

@export var strategy: ScoreStrategy

@onready
var _content_text := $BoxContainer/Padding/ContentText

enum StrategySlot {
	ENTER = -0, NEXT = 0, BREAK = 1, CHECK = 2
}

func _ready():
	_update_content()
	clear_all_slots()
	
	var start_index = 1 
	
	set_slot(
		0 + start_index, true, 0, Color.GREEN, 
		true, 0, Color.GREEN,
	)
	
	set_slot(
		1 + start_index, false, 0, Color.GREEN, 
		true, 0, Color.RED,
	)
	
	set_slot(
		2 + start_index, false, 0, Color.GREEN, 
		true, 0, Color.GRAY,
	)
	


func _update_content():
	if not strategy:
		return
		
	var properties = strategy.get_script().get_script_property_list()
	var string = ''
	for property in properties:
		var usage = property["usage"]
		var hint = property["hint"]
		if usage & PROPERTY_USAGE_EDITOR and hint == 0:
			var name = property["name"]
			var value = strategy.get(name)
			string = (string + "\n" if len(string) else "") + ("%s: %s" % [name, value])
			
	_content_text.text = string
