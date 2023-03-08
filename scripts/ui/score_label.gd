extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.on_event.connect(handle_event)


func handle_event(event: EventBase):
	if event is ScoreChanged:
		var score_changed := event as ScoreChanged
			
		text = str(score_changed.new_score)
		
		if score_changed.change_type == ScoreChanged.ChangeType.increment:
			animate_scale()
	
	
var tween: Tween
func animate_scale():
	if tween: tween.kill()
	
	tween = create_tween()
	tween.tween_property(
		self, "scale", 
		Vector2.ONE * 1.1, .150
	)
	tween.tween_property(
		self, "scale", 
		Vector2.ONE, .150
	)
