extends Control

class_name BackgroundNode

@onready
var _arrows := $Arrows

@onready
var _arrows_animation_player := $Arrows/Column/AnimationPlayer

func _ready():
	set_arrows_visible(false, 0)
	if get_parent() is Window:
		var tween = create_tween()
		tween.tween_interval(2)
		tween.tween_callback(func(): set_arrows_visible(true))
		tween.tween_interval(2)
		tween.tween_callback(func(): tune_arrows_speed(3))
		tween.tween_interval(2)
		tween.tween_callback(func(): tune_arrows_speed(2))
		tween.tween_interval(2)
		tween.tween_callback(func(): tune_arrows_speed(1))
		tween.tween_interval(2)
		tween.tween_callback(func(): set_arrows_visible(false))
		tween.set_loops()


var _fade_tween: Tween
func set_arrows_visible(
	value: bool, duration := .200,
	transition := Tween.TRANS_CUBIC, ease := Tween.EASE_OUT
):
	if _fade_tween:
		_fade_tween.kill()
		
	var color = Color.WHITE if value else Color.TRANSPARENT
	_fade_tween = create_tween()
	_fade_tween.set_trans(transition)
	_fade_tween.set_ease(ease)
	
	_fade_tween.tween_property(_arrows, "modulate", color, .250)
	
	if value:
		_arrows_animation_player.play("loop")
	else:
		_fade_tween.tween_callback(
			func(): 
				_arrows_animation_player.stop()
				_arrows_animation_player.speed_scale = 1
		)


var _speed_tween: Tween
func tune_arrows_speed(
	speed: float, duration: float = .200, 
	transition := Tween.TRANS_CUBIC, ease := Tween.EASE_OUT
):
	if _speed_tween:
		_speed_tween.kill()
		
	_speed_tween = create_tween()
	_speed_tween.set_trans(transition)
	_speed_tween.set_ease(ease)
	
	_speed_tween.tween_property(_arrows_animation_player, "speed_scale", speed, duration)
		
