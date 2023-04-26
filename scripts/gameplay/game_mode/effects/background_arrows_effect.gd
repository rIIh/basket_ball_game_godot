extends GameEffect

class_name BackgroundArrowsEffect

@export
var background: BackgroundNode

@export
var speed: float = 1

@export
var modulation: float = 1


func enter():
	if background:
		background.set_arrows_visible(true)
		background.tune_arrows_speed(speed)


func exit():
	if background:
		background.set_arrows_visible(false)
