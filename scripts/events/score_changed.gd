extends EventBase

class_name ScoreChanged

enum ChangeType {
	reset,
	increment
}

var prev_score: int
var new_score: int
var change_type: ChangeType

func _init(prev_score: int, new_score: int, change_type: ChangeType):
	self.prev_score = prev_score
	self.new_score = new_score
	self.change_type = change_type
	
static func increment(prev_score: int, new_score: int) -> ScoreChanged:
	return ScoreChanged.new(prev_score, new_score, ChangeType.increment)
	
static func reset(prev_score: int, new_score := 0) -> ScoreChanged:
	return ScoreChanged.new(prev_score, new_score, ChangeType.reset)
	
