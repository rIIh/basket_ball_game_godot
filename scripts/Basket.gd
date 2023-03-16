@tool
extends Sprite2D


## collisions are counted while ring in front of ball.
signal on_ball_dropped(collisions: int);

var collisions: int = 0;

@export var ring_is_over = false :
	set(value):
		_toggle(value);
		ring_is_over = value;
	
func _set(property, value) -> bool:
	if (property == "ring_is_over"):
		ring_is_over = value
		return true
		
	return false

func _toggle(value: bool):
	if not value:
		collisions = 0
	
	var sprite := $ring_sprite as Sprite2D
	sprite.z_index = 2 if value else 0;
	
	var sides = $ring/ring_sides
	var counter = $ring/counter_detector
	var cloth = $ring/cloth
	
	_toggle_collision_shapes(sides, value)
	_toggle_collision_shapes(counter, value)
	_toggle_collision_shapes(cloth, value)

func enable_colliders_and_front_sprite():
	ring_is_over = true;
		
func disable_colliders_and_front_sprite():
	ring_is_over = false;
	
func _toggle_collision_shapes(node: Node, value: bool):
	for child in node.get_children():
		if not child is CollisionShape2D and not child is CollisionPolygon2D:
			continue;
			
		if child.get_meta("ignore", false):
			continue;
			
		var collider = child;
		collider.call_deferred('set_disabled', !value)

func _on_counter_detector_body_entered(body):
	on_ball_dropped.emit(collisions)
	Events.dispatch(BallDropped.new())

func _on_ring_sides_body_entered(body):
	collisions += 1;
