extends RigidBody2D

var dragging = false
func set_dragging(value: bool):
	if dragging and !value:
		drag_just_ended = true;
	dragging = value;
	
	
var drag_start_position: Vector2;
var drag_end_position: Vector2;
var drag_just_ended = false;
var tap_radius = 1280  # Size of the sprite
var respawn = -1;
var reset = false;

@export var fly_time: float = 5;
@export var end_size: float = .5;
@export var size_end_time: float = .5;
@export var strength: float = 4;

@onready
var initial_position = position;

@onready
var initial_size = self.scale;

@onready
var initial_collider_size = $Collider.scale;

func get_time() -> float:
	return fly_time - respawn;

func compute_scale(initial_scale: Vector2):
	var scale_time = clamp(get_time() / size_end_time, 0 ,1);
	return lerp(initial_scale, end_size * initial_scale, scale_time);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if respawn < 0:
		set_freeze_enabled(true);
		self.scale = initial_size;
		$Collider.scale = initial_collider_size;
	else:
		self.scale = compute_scale(initial_size);
		$Collider.scale = compute_scale(initial_collider_size);
		
	if drag_just_ended:
		drag_just_ended = false;
	
		
	if respawn > 0:
		respawn -= delta;
		if respawn < 0:
			reset = true;

func _integrate_forces(state):
	if reset:
		state.transform.origin = initial_position
		state.linear_velocity = Vector2()
		reset = false

func _input(event):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
		if (event.position - position).length() < tap_radius:
			if !dragging and event.pressed:
				drag_start_position = event.position;
				set_dragging(true)
				
		if dragging and !event.pressed:
			drag_end_position = event.position;
			set_dragging(false)

	if drag_just_ended:
		drag_just_ended = false;
		handle_drag_end();
		

func handle_drag_end():
	print('applying impulse')
	set_freeze_enabled(false)
	
	var direction = (drag_end_position - drag_start_position).normalized()
	
	apply_impulse(1000 * strength * direction);
	respawn = fly_time;
