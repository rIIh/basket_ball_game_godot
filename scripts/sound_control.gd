extends Control

@onready
var animation_player = $AnimationPlayer

@onready
var button = $MarginContainer/Sound

var sound_on = true

func _ready():
	button.button_up.connect(_handle_sound_toggle)

func _handle_sound_toggle():
	sound_on = !sound_on
	
	if sound_on:
		animation_player.play_backwards("sound_off")
	else:
		animation_player.play("sound_off")
	
