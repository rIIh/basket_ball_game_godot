extends RigidBody2D

@export var initial_impulse: float = 2
@export var direction_spread: float = 30
@export var horizontal_position_spread: float = 30

var _reset = false
var _resetted = false

func _ready():
	visible = false
	$AnimationPlayer.animation_finished.connect(_freeze)

func _freeze(_value):
	sleeping = true
	print("freeze")

func _animate_text_color():
	$AnimationPlayer.play("fade_text")


func bump(value: int = 1):
	_reset = true
	_after_bump()
	
	$CanvasGroup/Text.text = "+%s" % value


func _process(delta):
	if _resetted:
		_after_bump()
		_resetted = false
		

func _after_bump():
	var angle = randf_range(-direction_spread, direction_spread)
	var direction = Vector2.UP.rotated(deg_to_rad(angle))
	apply_torque(10)
	apply_impulse(100 * direction * initial_impulse)
	_animate_text_color()


func _integrate_forces(state):
	if _reset:
		state.linear_velocity = Vector2.ZERO
		state.transform.origin = get_parent().global_position
		
		if horizontal_position_spread > 0:
			state.transform.origin.x += randf_range(
				-horizontal_position_spread,
				horizontal_position_spread
			)
		
		_reset = false
		_resetted = true
		visible = true	
