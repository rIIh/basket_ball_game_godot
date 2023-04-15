extends Control

class_name OffsetButtonEffect

@export
var target: Control

@export
var enabled: bool = true

@export
var offset: float = 15

@onready
var initial_offset_left = target.offset_left
@onready
var initial_offset_top = target.offset_top
@onready
var initial_offset_right = target.offset_right
@onready
var initial_offset_bottom = target.offset_bottom

var _pressed = false;

func _input(event):
	if not enabled:
		return;
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_handle_tap_down()
			else:
				_handle_tap_up()
		
var _tween: Tween

func _handle_tap_down():
	if _pressed: 
		return
	
	_pressed = true
	
	if _tween:
		_tween.kill()
	
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(target, 'offset_left', initial_offset_left + offset, 0.15)
	_tween.tween_property(target, 'offset_top', initial_offset_top + offset, 0.15)
	_tween.tween_property(target, 'offset_right', initial_offset_right + offset, 0.15)
	_tween.tween_property(target, 'offset_bottom', initial_offset_bottom + offset, 0.15)
	_tween.play()
	
	
func _handle_tap_up():
	if not _pressed: 
		return
		
	_pressed = false
	
	if _tween:
		_tween.kill()
	
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(target, 'offset_left', initial_offset_left, 0.15)
	_tween.tween_property(target, 'offset_top', initial_offset_top, 0.15)
	_tween.tween_property(target, 'offset_right', initial_offset_right, 0.15)
	_tween.tween_property(target, 'offset_bottom', initial_offset_bottom, 0.15)
	_tween.play()
