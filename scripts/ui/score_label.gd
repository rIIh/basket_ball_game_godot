extends Node2D


@export var particle_count := 5

## in degrees
@export var direction_spread := 10


var emitters: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	$particles.one_shot = true
	$particles.emitting = false
	
	if ($particles.visible):
		setup_emitters()
	
	Events.on_event.connect(handle_event)
	$Label.text = str(Score.session.score)
	$Label.scale = Vector2.ONE if Score.session.score > 0 else Vector2.ZERO


var state_tween: Tween
func handle_event(event: EventBase):
	if event is GameStateChanged:
		event = event as GameStateChanged
		
		state_tween = create_tween()
		if event.next_state != GameState.playing:
			state_tween.tween_property($Label, "scale", Vector2.ZERO, .150).set_ease(Tween.EASE_OUT)
			state_tween.tween_callback(func(): $Label.text = "0")
		elif Score.session.score > 0:
			state_tween.tween_property($Label, "scale", Vector2.ONE, .230).set_ease(Tween.EASE_OUT)
			
			

	if event is ScoreChanged:
		event = event as ScoreChanged
		
		if event.change_type == ScoreChanged.ChangeType.increment:
			$Label.text = str(event.new_score)
			
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
	
	
