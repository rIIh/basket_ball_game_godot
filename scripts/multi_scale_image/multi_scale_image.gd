@tool
extends Sprite2D

class_name MultiScaleImage

@export var multi_scale_texture: MultiScaleTexture
@export var render_scale: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		texture = multi_scale_texture.get_texture(render_scale)
