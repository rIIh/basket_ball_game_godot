extends Node2D


@export var particle_count := 5

## in degrees
@export var direction_spread := 10


var emitters: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	$particles.one_shot = true
	$particles.emitting = false
	
	setup_emitters()
	
	Events.on_event.connect(handle_event)
	$Label.text = str(Score.session.score)


func handle_event(event: EventBase):
	if event is ScoreChanged:
		var score_changed := event as ScoreChanged
			
		$Label.text = str(score_changed.new_score)
		
		if score_changed.change_type == ScoreChanged.ChangeType.increment:
			for emitter in emitters:
				emitter.restart()
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

func setup_emitters():
	$particles.visible = false
	
	for i in particle_count:
		var angle = float(i) / particle_count * 2 * PI
		
		var direction = Vector2.UP.rotated(angle)
		
		var clone = ($particles.duplicate()) as CPUParticles2D
		clone.visible = true
		clone.set_amount(1)
		clone.set_direction(direction)
		clone.set_spread(direction_spread)
		
		add_child(clone)
		emitters.append(clone)
	
	
