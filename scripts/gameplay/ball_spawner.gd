@tool
extends Node2D

class_name BallSpawner

@export
var ball_body_template_path: NodePath

@export
var spawn_anchor: NodePath

@export
var distance: float = 0

@onready
var ball_body_template: Node2D = get_node(ball_body_template_path)

func _ready():
	ball_body_template.visible = Engine.is_editor_hint()
	ball_body_template.process_mode = Node.PROCESS_MODE_DISABLED
	pass

func _process(delta):
	if Engine.is_editor_hint():
		var ball_body = get_node(ball_body_template_path);
		var anchor = get_node(spawn_anchor) as Node2D
		ball_body.position = anchor.position
	
		queue_redraw()


func _draw():
	if not Engine.is_editor_hint():
		return
		
	if spawn_anchor != null:
		var node = get_node(spawn_anchor) as Node2D
		draw_circle(node.position, 8, Color.RED)
		
		if distance > 0:
			draw_line(node.position, node.position + Vector2.RIGHT * distance / 2, Color.RED, 4, true)
			draw_line(node.position, node.position + Vector2.LEFT * distance / 2, Color.RED, 4, true)

func spawn(alignment: float = 0) -> BallBody:
	var node: BallBody = _get_ball_body(ball_body_template).duplicate()
	node.visible = true
	node.position += ball_body_template.position
	node.position.x += distance / 2 * alignment
	get_parent().add_child(node)
	
	return node
	

func _get_ball_body(node: Node) -> BallBody:
	if node is BallBody:
		return node
		
	if node.get_child_count() > 0:
		for child in node.get_children():
			var ball_body = _get_ball_body(child)
			if ball_body:
				return ball_body
	
	return null
