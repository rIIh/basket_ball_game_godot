extends Node2D


@export var max_swipe_distance: float = 300;

var ball_body_original;
var ball_body;

var over_body = false;
var dragging = false
var drag_breaked = false;
func set_dragging(value: bool):
	if dragging and !value:
		drag_just_ended = true;
	dragging = value;
	
	
var drag_start_position: Vector2;
var drag_end_position: Vector2;
var drag_just_ended = false;

func _ready():
	Engine.time_scale = .25
	ball_body_original = $ball_body
	ball_body_original.disable()
	_respawn(null)


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


func _on_out_area_body_entered(body):
	_respawn(body);

func _respawn(ball: Node):
	if ball:
		remove_child(ball);
		
	var new_ball: Node = ball_body_original.duplicate()
	add_child(new_ball)
	
	new_ball.enable()
	ball_body = new_ball
	
	$basket.disable_colliders_and_front_sprite();

func _on_basket_enable_area_entered(body):
	$basket.enable_colliders_and_front_sprite();

func _on_ball_body_input_event(viewport, event: InputEvent, shape_idx):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
		if !dragging and !drag_breaked and event.pressed and over_body:
			drag_start_position = event.position;
			set_dragging(true)

func _on_ball_body_mouse_entered():
	over_body = true;

func _on_ball_body_mouse_exited():
	over_body = false;

func handle_drag_end():
	var direction = (drag_end_position - drag_start_position).normalized()
	ball_body.push(direction)


