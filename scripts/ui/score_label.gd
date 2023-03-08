extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$particles.one_shot = true
	$particles.emitting = false
	Events.on_event.connect(handle_event)


func handle_event(event: EventBase):
	if event is ScoreChanged:
		var score_changed := event as ScoreChanged
			
		$Label.text = str(score_changed.new_score)
		
		if score_changed.change_type == ScoreChanged.ChangeType.increment:
			$particles.restart()
			animate_scale()
	
	
var tween: Tween
func animate_scale():
	if tween: tween.kill()
	
	tween = create_tween()
	tween.tween_property(
		$Label, "scale", 
		Vector2.ONE * 1.1, .150
	)
	tween.tween_property(
		$Label, "scale", 
		Vector2.ONE, .150
	)
