extends RigidBody2D

class_name BallBody

@export var tap_to_launch = false;

@export var strength: float = 7;
@export var size_duration: float = 1;
@export var end_size: float = .65;

var flying_time: float = 0;

@onready
var initial_sprite_size = $ball_sprite.scale

@onready
var initial_collider_size = $collider.scale


func _process(delta):
	if visible and not freeze:
		flying_time += delta;
		update_scale();
		
func _input(event):
	if not visible or not tap_to_launch: 
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and freeze:
		print('mouse push')
		push(Vector2.UP)
		
	
func update_scale():
	var time = flying_time / size_duration;
	time = clamp(time, 0, 1);
	
	$ball_sprite.scale = lerp(
		initial_sprite_size, 
		initial_sprite_size * end_size,
		time
	);
	
	$collider.scale = lerp(
		initial_collider_size, 
		initial_collider_size * end_size, 
		time
	);
	
func enable():
	visible = true;
	process_mode = Node.PROCESS_MODE_INHERIT
	
func disable():
	visible = false;
	process_mode = Node.PROCESS_MODE_DISABLED

func push(direction: Vector2):
	if not visible:
		return;
		
	print('pushing', direction)
	set_freeze_enabled(false);
	apply_impulse(1000 * strength * direction);
