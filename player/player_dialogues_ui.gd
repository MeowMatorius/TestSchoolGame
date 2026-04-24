extends Control

@export var dialogue_ui: Control
@export var speaker_name: Label
@export var speaker_line: Label
@export var choice_ui: VBoxContainer


func _ready() -> void:
	DialogueManager.started_talking.connect(show_ui)
	DialogueManager.stoped_talking.connect(hide_ui)
	DialogueManager.start_choosing.connect(show_choices)


func show_ui(speaker, line):
	dialogue_ui.visible = true
	speaker_name.text = speaker
	speaker_line.text = line
	
	
func hide_ui():
	dialogue_ui.visible = false
	
	
func show_choices(choices_array):
	var choices = choice_ui.get_children()
	print("вот такие выборы ", choice_ui.get_children())
	for i in range(choices.size()):
		choices[i].visible = true
		choices[i].text = choices_array[i]
#	choice_1.visible = true	
#	choice_2.visible = true
#	choice_1.text = choices_array[0]
#	choice_2.text = choices_array[1]
	
	
