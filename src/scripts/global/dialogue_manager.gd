extends Node

# var all_dialogues: Dictionary[Variant, Variant] = {} # Здесь храним весь файл
# var current_dialogue_key: String = ""
# var dialogue_data: Array[Variant] = []
# var current_step: int = 0
# var path: String
# var choices_array: Array[Variant] = []
# var count:int = 0
# var dialogue_all: Dictionary = {}
# @export var dialogue_data: DialogueData
# @export var dialogue_choice: DialogueChoice

var event_bool: bool = false
var event_id: String

signal started_talking
signal start_choosing
signal start_quest


func _ready() -> void: 
	EventManager.triggered_event.connect(check_line_type)
	SignalBus.is_talking.connect(enter_dialogue_state)


func enter_dialogue_state(npc_data):                                  
	GameManager.current_game_state = GameManager.GameState.DIALOGUE
#	GameManager.current_game_camera = dialogue_camera

	if event_bool:
		display_line(npc_data.event_dialogues[0], npc_data)
		event_bool = false
	else:
		display_line(npc_data.dialogue_data, npc_data)


func check_line_type(id):
	print('Получил сигнал')
	event_bool = true
	event_id = id
	

func display_line(dialogue_data, npc_data):
	_on_option_button_pressed(dialogue_data)
	started_talking.emit(dialogue_data.character_name, dialogue_data.text)
#	track_quest(dialogue_data.quest)
	if dialogue_data.choices.size() == 0:
		await InputManager.skip_pressed
	if dialogue_data.next_dialogue != null:
		display_line(dialogue_data.next_dialogue, npc_data)
	elif dialogue_data.choices.size() != 0:
		start_choosing.emit(dialogue_data, npc_data)
	else:
		end_dialogue()


func _on_option_button_pressed(dialogue_data) -> void:

	for i in dialogue_data.commands:
	# Фабрика создает команду, используя тип из ресурса и прикрепленный квест
		var command := DialogueCommandFactory.create_command(
			i.command_type, 
			i
		)
		
		if command:
			command.execute(get_tree())


func _on_choice_selected(next_node_id, condition, dialogue_line_1, npc_data):
	_on_option_button_pressed(dialogue_line_1)
	get_item(condition)
#	track_quest(quest)
	if next_node_id != null:
		display_line(next_node_id, npc_data)
	else:
		end_dialogue()


#func track_quest(quest_list):
#	if quest_list != null:
#		for quest in quest_list:
#			QuestManager.track_quest(quest)


func get_item(condition):
	for i in condition:
		if i.item_given != null:
			InventoryManager.add_item(i.item_given)
			InventoryManager.remove_item(i.item, i.item_quantity)


func end_dialogue():
	GameManager.current_game_state = GameManager.GameState.DEFAULT
	GameManager.current_game_camera = GameManager.player_camera
