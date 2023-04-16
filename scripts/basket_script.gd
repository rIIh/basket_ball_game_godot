@tool
extends Sprite2D


signal on_ball_dropped(collisions: int);

var collisions_records: Dictionary = {}

func _ready():
	for nodes in [$ring/ring_sides, $ring/counter_detector, $ring/cloth]:
		_toggle_collision_shapes(nodes, true)
	


func _toggle_collision_shapes(node: Node, value: bool):
	for child in node.get_children():
		if not child is CollisionShape2D and not child is CollisionPolygon2D:
			continue;
			
		if child.get_meta("ignore", false):
			continue;
			
		var collider = child;
		collider.call_deferred('set_disabled', !value)

func _on_counter_detector_body_entered(body: Node2D):
	var id = body.get_instance_id();
	var collisions = collisions_records[id] if collisions_records.has(id) else 0
	
	on_ball_dropped.emit(collisions)
	Events.dispatch(BallDropped.new())

func _on_ring_sides_body_entered(body: Node2D):
	var id = body.get_instance_id();
	if collisions_records.has(id):
		collisions_records[id] += 1
	else:
		collisions_records[id] = 1
