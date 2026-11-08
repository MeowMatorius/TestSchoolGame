extends Control

@export var speaker_name: Label
@export var speaker_line: Label
#@export var choice_ui: VBoxContainer
#
#@onready var choices: Array[Node] = choice_ui.get_children()

@onready var choices_container: VBoxContainer = $MarginContainer2/ScrollContainer/ChoiceContainer
@onready var choice_default_button: Button = $ChoiceDefault  # ваша настроенная кнопка
@onready var choice_for_quest_button: Button = $ChoiceForQuest


func _ready() -> void:
	SignalBus.started_talking.connect(show_ui)
	SignalBus.start_choosing.connect(show_choices)


func show_ui(speaker, line):
	speaker_name.text = speaker
	speaker_line.text = line

func show_choices(dialogue_data, npc_data):
	if DialogueManager.active_quest_dialogues.has(npc_data) and not DialogueManager.active_quest_dialogues[npc_data].is_empty():
		print_choices(DialogueManager.active_quest_dialogues[npc_data], npc_data, choice_for_quest_button)
	print_choices(dialogue_data.choices, npc_data, choice_default_button)
	

func print_choices(source_dialogues, npc_data, button_type):
	for option in range(source_dialogues.size()):
# Клонируем шаблон (true = дублировать и сигналы, и дочерние узлы)
		var button: Button = button_type.duplicate()
		if button.pressed.is_connected(_on_choice_selected):
			button.pressed.disconnect(_on_choice_selected)
		button.text = source_dialogues[option].text
		button.visible = true                      # показываем клон
		button.pressed.connect(_on_choice_selected.bind(source_dialogues[option], npc_data))
		
		# Добавляем клон в контейнер
		choices_container.add_child(button)

func clear_options() -> void:
	for child in choices_container.get_children():
		print('Очистили ', child)
		child.queue_free()
		
		
#func show_choices(dialogue_data, npc_data):
#	var all_choices: Array = []
#	
#	SignalBus.entered_choice_menu.emit(true)
#	speaker_name.text = dialogue_data.character_name
#	
#	_get_quest_choices(npc_data.quest_dialogues, all_choices)
#	all_choices.append_array(dialogue_data.choices)
#	for i in range(choices.size()):
#		var button = choices[i]
#		
#		# Отключаем старое соединение, если оно существует, чтобы избежать дублирования
#		if button.pressed.is_connected(_on_choice_selected):
#			button.pressed.disconnect(_on_choice_selected)
#		
#		if i < all_choices.size():
#			if all_choices[i].condition != null:
#				button.disabled = !_disabled_condition(all_choices[i].condition)
#			for j in all_choices[i].commands:
#				if j.command_type == CommandFactory.CommandType.END_QUEST:
#					button.add_theme_color_override("font_color", Color(0.875, 0.875, 0.078))
#			button.visible = true
#			button.text = all_choices[i].text
#			# Подключаем сигнал к функции, передавая нужную ветку через bind
#			button.pressed.connect(_on_choice_selected.bind(all_choices[i], npc_data))
#		else:
#			# Скрываем лишние кнопки, если вариантов выбора меньше, чем кнопок в UI
#			button.visible = false
#
#func  _disabled_condition(condition):
#	return condition.all(func(cond): return cond.is_met())
#
func _on_choice_selected(choice, npc_data):
	clear_options()
	DialogueManager.display_line(choice, npc_data)
#	
#func _clear_ui():
#	for i in range(choices.size()):
#		choices[i].text = ""
#		choices[i].visible = false
#		choices[i].add_theme_color_override("font_color", Color(0.875, 0.875, 0.875))
#
#func _get_quest_choices(quest_dialogues, all_choices):
#	if quest_dialogues != null:
#		for quest_line in quest_dialogues:
#			for command in quest_line.commands:
#				if command.quest in QuestManager.active_quests:
#					all_choices.append(quest_line)
