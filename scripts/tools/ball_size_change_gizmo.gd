@tool
extends Node2D

class_name BallSizeChangeGizmo

@export
var color := Color.RED :
	set(value):
		color = value
		queue_redraw()

@onready
var ball: BallBody = self.get_parent()

@onready
var _size = ball.end_size

func _ready():
	visible = Engine.is_editor_hint();

func _process(delta):
	if ball.end_size != _size:
		_size = ball.end_size
		queue_redraw()

func _draw():
	var size = (ball.get_node("collider") as CollisionShape2D).shape.get_rect().size.x / 2 * _size
	draw_circle(Vector2.ZERO, size, color)
