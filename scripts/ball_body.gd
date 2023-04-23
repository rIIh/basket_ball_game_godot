extends RigidBody2D

class_name BallBody

@export_group("Swipe Rules")
@export var min_swipe_distance: float = 20;
@export var max_swipe_distance: float = 300;
@export var max_push_direction_angle: float = 75

@export_group("Other")
@export var strength: float = 7;
@export var size_duration: float = 1;
@export var end_size: float = .65;

var flying_time: float = 0;
var collisions: int = 0;
var dropped: bool = false :
	set(value):
		if value != dropped and value:
			dropped = value
			ball_dropped.emit()

		dropped = value

@onready
var initial_sprite_size = $ball_sprite.scale

@onready
var initial_collider_size = $collider.scale

var is_collisions_enabled = false :
	set(value):
		is_collisions_enabled = value
		var worldCollisions = 1 << (Constant.kWorldCollisionLayer - 1)
		var counterCollions = 1 << (Constant.kCounterCollisionLayer - 1)
		
		if is_collisions_enabled:
			collision_mask = collision_mask | worldCollisions | counterCollions
			collision_layer = collision_layer | worldCollisions | counterCollions
		else:
			collision_mask = collision_mask & ~worldCollisions & ~counterCollions
			collision_layer = collision_layer & ~worldCollisions & ~counterCollions
			

signal ball_interacted
signal ball_dropped
signal ball_pushed

func _ready():
	is_collisions_enabled = is_collisions_enabled


func _process(delta):
	if visible and not freeze:
		flying_time += delta;
		update_scale();
		
		
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
		
	set_freeze_enabled(false);
	apply_impulse(1000 * strength * direction);
	ball_pushed.emit()


var dragging = false
var drag_breaked = false;
func set_dragging(value: bool):
	if dragging and !value:
		drag_just_ended = true;
	dragging = value;
	
	ball_interacted.emit()
	
	
var drag_start_position: Vector2;
var drag_end_position: Vector2;
var drag_just_ended = false;
var over_body = false;

func _input(event):
	if event is InputEventMouseMotion:
		if dragging and (event.position - drag_start_position).length() > max_swipe_distance:
			drag_breaked = true;
			drag_end_position = event.position;
			set_dragging(false)
			
			
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
		if !drag_breaked and dragging and !event.pressed:
			drag_end_position = event.position;
			set_dragging(false)
		
		if !event.pressed and drag_breaked:
			drag_breaked = false;

	if drag_just_ended:
		drag_just_ended = false;
		handle_drag_end();


func _on_ball_body_input_event(viewport, event: InputEvent, shape_idx):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
		if !dragging and !drag_breaked and event.pressed and over_body:
			drag_start_position = event.position;
			set_dragging(true)

func handle_drag_end():
	var distance = (drag_end_position - drag_start_position)
	var direction = distance.normalized()
	var angle = rad_to_deg(direction.angle_to(Vector2.UP))
	
	if abs(angle) < max_push_direction_angle and distance.length() > min_swipe_distance:
		push(direction)

func _on_ball_body_mouse_entered():
	over_body = true;

func _on_ball_body_mouse_exited():
	over_body = false;
