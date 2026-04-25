extends Control

@export var speaker_name: Label
@export var speaker_line: Label
@export var choice_ui: VBoxContainer


func _ready() -> void:
	DialogueManager.started_talking.connect(show_ui)
	DialogueManager.start_choosing.connect(show_choices)


func show_ui(speaker, line):
	speaker_name.text = speaker
	speaker_line.text = line
	
	
func show_choices(choices_array):
	var choices: Array[Node] = choice_ui.get_children()
	print("вот такие выборы ", choice_ui.get_children())
	for i in range(choices.size()):
		choices[i].visible = true
		choices[i].text = choices_array[i]
	
