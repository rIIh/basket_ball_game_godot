extends EventBase

class_name ScoreChanged

enum ChangeType {
	reset,
	increment
}

var new_score: int
var change_type: ChangeType

func _init(new_score: int, change_type: ChangeType):
	self.new_score = new_score
	self.change_type = change_type
	
static func increment(new_score: int) -> ScoreChanged:
	return ScoreChanged.new(new_score, ChangeType.increment)
	
static func reset(new_score := 0) -> ScoreChanged:
	return ScoreChanged.new(new_score, ChangeType.reset)
	
