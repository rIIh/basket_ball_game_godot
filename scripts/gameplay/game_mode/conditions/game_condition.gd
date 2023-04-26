extends GameModeDescendant

class_name GameCondition

enum ConditionResult {
	ACTIVATE,
	DEACTIVATE
}

@export
var condition_result: ConditionResult = ConditionResult.ACTIVATE

@export
var reset_on: GameCondition

@export
var reset_on_self: bool = false

signal on_triggered(result: ConditionResult)

func _ready():
	super._ready()
	
	if reset_on:
		reset_on.on_triggered.connect(reset)

func trigger(result: ConditionResult = condition_result):
	for child in get_children():
		if child is GameEffect:
			match result:
				ConditionResult.ACTIVATE:
					child.activate()
				ConditionResult.DEACTIVATE:
					child.deactivate()

	propagate(result)


func propagate(result: ConditionResult = condition_result):
	var node: Node
	while true:
		node = get_parent()
		if node == null or node is GameCondition or node is GameModeNext:
			break
	
	if node != null and node is GameCondition:
		node.trigger(condition_result)

func reset(result: ConditionResult = condition_result):
	pass
