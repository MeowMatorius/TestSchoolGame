extends Control

@export var dialogue_ui: Control
@export var speaker_name: Label
@export var speaker_line: Label


func _ready() -> void:
	DialogueManager.started_talking.connect(show_ui)
	DialogueManager.stoped_talking.connect(hide_ui)


func show_ui(speaker, line):
	dialogue_ui.visible = true
	speaker_name.text = speaker
	speaker_line.text = line
	
	
func hide_ui():
	dialogue_ui.visible = false
