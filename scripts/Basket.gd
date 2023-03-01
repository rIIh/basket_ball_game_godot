extends Sprite2D

var body_in_area: RigidBody2D


@onready
var ring: Node = $Ring

@onready
var ring_front: Sprite2D = $RingFront

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_enable_trigger_body_entered(body):
	ring_front.visible = true;
	for child in ring.get_children():
		var collider = child as CollisionShape2D
		collider.call_deferred('set_disabled', false)


func _on_disable_trigger_body_entered(body):
	ring_front.visible = false;
	for child in ring.get_children():
		var collider = child as CollisionShape2D
		collider.call_deferred('set_disabled', true)
