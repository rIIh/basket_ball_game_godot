extends Sprite2D


func _toggle(value: bool):
	$ring_front_sprite.visible = value;
	for child in $ring.get_children():
		if not child is CollisionShape2D:
			continue;
			
		var collider = child as CollisionShape2D;
		collider.call_deferred('set_disabled', !value)

func enable_colliders_and_front_sprite():
	_toggle(true);
		
func disable_colliders_and_front_sprite():
	_toggle(false);
	
