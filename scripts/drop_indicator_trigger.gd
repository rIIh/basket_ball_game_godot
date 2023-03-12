extends Control


func _ready():
	Events.on_event.connect(_listen)

func _listen(event: EventBase):
	if not event is ScoreChanged: return
	event = event as ScoreChanged
	
	if event.new_score > event.prev_score:
		$"Drop Indicator".bump(event.new_score - event.prev_score)
	
