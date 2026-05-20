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

	
func show_choices(dialogue_data, npc_data):
	var all_choices: Array = []
	all_choices.append_array(dialogue_data.choices)
	SignalBus.entered_choice_menu.emit(true)
	speaker_name.text = dialogue_data.character_name
	
	if npc_data.quest_dialogues != null:
		for quest_line in npc_data.quest_dialogues:
			if quest_line.end_quest in QuestManager.active_quests:
				all_choices.append(quest_line)
	
	for i in range(choices.size()):
		var button = choices[i]
		
		# Отключаем старое соединение, если оно существует, чтобы избежать дублирования
		if button.pressed.is_connected(_on_choice_selected):
			button.pressed.disconnect(_on_choice_selected)
		
		if i < all_choices.size():
			if all_choices[i].condition != null:
				button.disabled = !_disabled_condition(all_choices[i].condition)
			if all_choices[i].end_quest != null:
				button.add_theme_color_override("font_color", Color(0.875, 0.875, 0.078))
			button.visible = true
			button.text = all_choices[i].text
			# Подключаем сигнал к функции, передавая нужную ветку через bind
			button.pressed.connect(_on_choice_selected.bind(all_choices[i], npc_data))
		else:
			# Скрываем лишние кнопки, если вариантов выбора меньше, чем кнопок в UI
			button.visible = false

func  _disabled_condition(condition):
	return condition.all(func(cond): return cond.is_met())

func _on_choice_selected(choice, npc_data):
	var next_dialogue = choice.next_dialogue
	var condition = choice.condition
	SignalBus.entered_choice_menu.emit(false)
	_clear_ui()
	DialogueManager._on_choice_selected(next_dialogue, condition, choice, npc_data)
	
func _clear_ui():
	for i in range(choices.size()):
		choices[i].text = ""
		choices[i].visible = false
