extends Node

var active_quest_dialogues: Dictionary = {}

func _ready() -> void:
	SignalBus.is_talking.connect(enter_dialogue_state)


func enter_dialogue_state(npc_data):                                  
	GameManager.current_game_state = GameManager.GameState.DIALOGUE
	
	display_line(npc_data.dialogue_data, npc_data)
	

func display_line(dialogue_data, npc_data):
#	if SignalBus.entered_choice_menu.emit(false):
#		SignalBus.entered_choice_menu.emit(false)
	_on_option_button_pressed(dialogue_data)
	SignalBus.started_talking.emit(dialogue_data.character_name, dialogue_data.text)

	if dialogue_data.choices.size() == 0:
		await SignalBus.skip_pressed
	if dialogue_data.next_dialogue != null:
		display_line(dialogue_data.next_dialogue, npc_data)
	elif dialogue_data.choices.size() != 0:
		SignalBus.start_choosing.emit(dialogue_data, npc_data)
		SignalBus.entered_choice_menu.emit(true)
	else:
		end_dialogue()


func _on_option_button_pressed(dialogue_data) -> void:

	for i in dialogue_data.commands:
	# Фабрика создает команду, используя тип из ресурса и прикрепленный квест
		var command := CommandFactory.create_command(i.command_type, i)
		
		if command:
			command.execute(get_tree())


#func _on_choice_selected(choice, npc_data):
#	SignalBus.entered_choice_menu.emit(false)
#	_on_option_button_pressed(choice)
#
#	if choice.next_dialogue != null:
#		display_line(next_node_id, npc_data)
#	elif 
#	else:
#		end_dialogue()


func end_dialogue():
	GameManager.current_game_state = GameManager.GameState.DEFAULT

func refresh_active_quest_dialogues(dialogue_data):
	print(dialogue_data)
	if not active_quest_dialogues.has(dialogue_data.npc):
		active_quest_dialogues[dialogue_data.npc] = []
	active_quest_dialogues[dialogue_data.npc].append(dialogue_data)
	print('Добавили квестовую фразу ', active_quest_dialogues)