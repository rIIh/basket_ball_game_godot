extends GameCondition

class_name BallDropComboCondition

enum DropType {
	NO_COLLISIONS,
	COLLISIONS,
	ALL,
}

@export
var trigger_drop_type: DropType = DropType.ALL

@export
var trigger_count: int = 0

var state: int = 0

func _ready():
	super._ready()
	
	game_mode.on_ball_dropped.connect(_check)
	game_mode.on_started.connect(func(): state = 0)


func _check(ball: BallBody):
	match trigger_drop_type:
		DropType.NO_COLLISIONS:
			if ball.collisions > 0:
				state = 0
			else:
				state += 1
		DropType.COLLISIONS:
			if ball.collisions == 0:
				state = 0
			else:
				state += 1
		DropType.ALL:
			state += 1
			
	if state == trigger_count:
		trigger()


func reset(result: GameCondition.ConditionResult = condition_result):
	state = 0
