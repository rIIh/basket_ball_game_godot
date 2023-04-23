@tool
extends EditorPlugin


const _kMainEditorScene := preload("res://addons/game-mode-editor/scenes/editor.tscn")

var editor_view: Control

func _init() -> void:
	self.name = 'GameModeEditor'

func _enter_tree() -> void:
	editor_view = _kMainEditorScene.instantiate()
	editor_view.hide()
	add_control_to_bottom_panel(editor_view, "Game Mode Editor")
#	_make_visible(false)


func _exit_tree() -> void:
	if editor_view:
		remove_control_from_bottom_panel(editor_view)
		editor_view.queue_free()


func _get_plugin_name() -> String:
	return "Game Mode"


func _make_visible(visible:bool) -> void:
	if editor_view:
		editor_view.visible = visible

func _handles(object) -> bool:
	if editor_view != null and object is GameMode:
		return editor_view.can_edit_game_mode(object)
	return false
	
func _edit(object) -> void:
	if object == null:
		return
		
#	_make_visible(true)
	if editor_view and editor_view:
		editor_view.edit_game_mode(object)
