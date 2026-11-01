extends Node


func _ready() -> void:
	SignalBus.is_talking.connect(enter_dialogue_state)


func enter_dialogue_state(npc_data):                                  
	GameManager.current_game_state = GameManager.GameState.DIALOGUE
	
	display_line(npc_data.dialogue_data, npc_data)
	

func display_line(dialogue_data, npc_data):
	_on_option_button_pressed(dialogue_data)
	SignalBus.started_talking.emit(dialogue_data.character_name, dialogue_data.text)

	if dialogue_data.choices.size() == 0:
		await SignalBus.skip_pressed
	if dialogue_data.next_dialogue != null:
		display_line(dialogue_data.next_dialogue, npc_data)
	elif dialogue_data.choices.size() != 0:
		SignalBus.start_choosing.emit(dialogue_data, npc_data)
	else:
		end_dialogue()


func _on_option_button_pressed(dialogue_data) -> void:

	for i in dialogue_data.commands:
	# Фабрика создает команду, используя тип из ресурса и прикрепленный квест
		var command := CommandFactory.create_command(i.command_type, i)
		
		if command:
			command.execute(get_tree())


func _on_choice_selected(next_node_id, _condition, dialogue_line_1, npc_data):
	_on_option_button_pressed(dialogue_line_1)

	if next_node_id != null:
		display_line(next_node_id, npc_data)
	else:
		end_dialogue()


func end_dialogue():
	GameManager.current_game_state = GameManager.GameState.DEFAULT
