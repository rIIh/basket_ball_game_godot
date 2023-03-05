@tool
extends Sprite2D


@export var ring_is_over = false :
	set(value):
		print('changed')
		_toggle(value);
		ring_is_over = value;
	
func _set(property, value) -> bool:
	if (property == "ring_is_over"):
		ring_is_over = value
		return true
		
	return false


func _toggle(value: bool):
	$ring_front_sprite.visible = value;
	for child in $ring.get_children():
		if not child is CollisionShape2D:
			continue;
			
		var collider = child as CollisionShape2D;
		collider.call_deferred('set_disabled', !value)

func enable_colliders_and_front_sprite():
	ring_is_over = true;
		
func disable_colliders_and_front_sprite():
	ring_is_over = false;
	
