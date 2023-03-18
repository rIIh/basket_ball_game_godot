extends Control

@export var last_score_label: Label
@export var best_score_label: Label
@export var animation_player: AnimationPlayer

var session_repository: SessionRepository

func _ready():
	session_repository = SessionProvider.repository
	
	Events.on_event.connect(handle_event)
	
	if animation_player == null:
		animation_player = $AnimationPlayer
	
func handle_event(_event: EventBase):
	if _event is GameStateChanged:
		var event := _event as GameStateChanged
		
		if event.next_state == GameState.finished:
			var last_session := session_repository.get_last_session()
			var best_session := session_repository.get_best_session()
			
			last_score_label.text = str(last_session.score)
			best_score_label.text = str(best_session.score)
			
			
			animation_player.speed_scale = 1
			animation_player.play("show")
			
		if event.next_state != GameState.finished:
			animation_player.speed_scale = 2
			animation_player.play_backwards()
		
