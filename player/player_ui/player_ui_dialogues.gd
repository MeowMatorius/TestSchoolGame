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
	SignalBus.entered_choice_menu.emit(true)
	for i in range(choices_array.size()):
		choices[i].visible = true
		choices[i].text = choices_array[i]["text"]
		
		choices[i].pressed.connect(func():
				SignalBus.entered_choice_menu.emit(false)
				_clear_ui()
				DialogueManager._on_choice_selected(choices_array[i]["next_node"]),
				CONNECT_ONE_SHOT)
	
	
func _clear_ui():
	for i in range(choices.size()):
		choices[i].text = ""
		choices[i].visible = false
