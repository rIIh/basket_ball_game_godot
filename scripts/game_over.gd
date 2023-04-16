extends Control

@export var last_score_label: Label
@export var best_score_label: Label
@export var animation_player: AnimationPlayer

@onready var last_score_template = last_score_label.text
@onready var best_score_template = best_score_label.text

var session_repository: SessionRepository

func _ready():
	session_repository = SessionProvider.repository
	
	Events.on_event.connect(handle_event)
	
	if animation_player == null:
		animation_player = $AnimationPlayer

	animation_player.animation_finished.connect(_scale_score)
	
	
func handle_event(_event: EventBase):
	if _event is GameStateChanged:
		var event := _event as GameStateChanged
		
		if event.next_state == GameState.finished:
			var last_session := session_repository.get_last_session()
			var best_session := session_repository.get_best_session()
			
			last_score_label.text = last_score_template % str(last_session.score)
			best_score_label.text = best_score_template % str(best_session.score)
			
			animation_player.speed_scale = 1
			animation_player.play("show")
			
			if _tween:
				_tween.kill()
				last_score_label.scale = Vector2.ONE
			
		if event.next_state != GameState.finished:
			animation_player.speed_scale = 2
			animation_player.play_backwards()

var _tween: Tween
func _scale_score(animation: String):
	if animation != 'show':
		return;
		
	if _tween:
		_tween.kill()
		
	_tween = create_tween();
	_tween.tween_property(last_score_label, "scale", Vector2(1.2, 1.2), 0.15)
	_tween.tween_property(last_score_label, "scale", Vector2.ONE, 0.15)
