@tool
extends Sprite2D


signal on_counted;

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
	var sprite := $ring_sprite as Sprite2D
	sprite.z_index = 2 if value else 0;
	
	var sides = $ring/ring_sides
	var counter = $ring/counter_detector
	
	_toggle_collision_shapes(sides, value)
	_toggle_collision_shapes(counter, value)


func enable_colliders_and_front_sprite():
	ring_is_over = true;
		
func disable_colliders_and_front_sprite():
	ring_is_over = false;
	
func _toggle_collision_shapes(node: Node, value: bool):
	for child in node.get_children():
		if not child is CollisionShape2D:
			continue;
			
		var collider = child as CollisionShape2D;
		collider.call_deferred('set_disabled', !value)
