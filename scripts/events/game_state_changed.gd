extends EventBase

class_name GameStateChanged

var previous_state: int
var next_state: int


func _init(previous_state: int, next_state: int):
	self.previous_state = previous_state
	self.next_state = next_state
