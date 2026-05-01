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

	
func show_choices(dialogue_line):
	SignalBus.entered_choice_menu.emit(true)
	print("выводим жоска")
	speaker_name.text = dialogue_line.character_name
	
	for i in range(choices.size()):
		var button = choices[i]
		
		# Отключаем старое соединение, если оно существует, чтобы избежать дублирования
		if button.pressed.is_connected(_on_choice_selected):
			button.pressed.disconnect(_on_choice_selected)
		
		if i < dialogue_line.choices.size():
			button.visible = true
			button.text = dialogue_line.choices[i]
			# Подключаем сигнал к функции, передавая нужную ветку через bind
			button.pressed.connect(_on_choice_selected.bind(dialogue_line.choices_branches[i]))
		else:
			# Скрываем лишние кнопки, если вариантов выбора меньше, чем кнопок в UI
			button.visible = false


func _on_choice_selected(branch_id):
	SignalBus.entered_choice_menu.emit(false)
	_clear_ui()
	DialogueManager._on_choice_selected(branch_id)
	
func _clear_ui():
	for i in range(choices.size()):
		choices[i].text = ""
		choices[i].visible = false
