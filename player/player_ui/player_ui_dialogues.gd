extends Control

@export var speaker_name: Label
@export var speaker_line: Label
@export var choice_ui: VBoxContainer

@onready var choices: Array[Node] = choice_ui.get_children()

func _ready() -> void:
	DialogueManager.started_talking.connect(show_ui)
	DialogueManager.start_choosing.connect(show_choices)


func show_ui(speaker, line):
	speaker_name.text = speaker
	speaker_line.text = line

	
func show_choices(choices_array):

	for i in range(choices_array.size()):
		print("Принял ", choices_array)
		choices[i].visible = true
		choices[i].text = choices_array[i]["text"]
		choices[i].pressed.connect(func():
				_clear_ui()
				DialogueManager._on_choice_selected(choices_array[i]["next_node"])
				print("Жмали ", choices_array[i]["next_node"]))
	
	
func _clear_ui():
	for i in range(choices.size()):
		choices[i].text = ""
		choices[i].visible = false
