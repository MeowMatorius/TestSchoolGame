extends Node

var all_dialogues: Dictionary[Variant, Variant] = {} # Здесь храним весь файл
var current_dialogue_key: String = ""
var dialogue_data: Array[Variant] = []
var current_step: int = 0
var path: String
var choices_array: Array[Variant] = []
var count:int = 0
var dialogue_all: Dictionary = {}

var event_bool: bool = false
var event_id: String

#@export var dialogue_line: DialogueLine
#@export var dialogue_choice: DialogueChoice

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
		display_line(npc_data.event_dialogues[0])
		event_bool = false
	else:
		display_line(npc_data.dialogue_line)
	

func check_line_type(id):
	print('Получил сигнал')
	event_bool = true
	event_id = id
	



func display_line(dialogue_line):
	call_comand(dialogue_line.text)
	started_talking.emit(dialogue_line.character_name, dialogue_line.text)
	track_quest(dialogue_line.quest)
	if dialogue_line.choices.size() == 0:
		await InputManager.skip_pressed
	if dialogue_line.next_dialogue != null:
		display_line(dialogue_line.next_dialogue)
	elif dialogue_line.choices.size() != 0:
		start_choosing.emit(dialogue_line)
	else:
		end_dialogue()
	
func call_comand(text):
	var clean_text = text
	if "[trigger:" in text:
		var start = text.find("[trigger:") + 9
		var end = text.find("]", start)
		var tag_content = text.substr(start, end - start)
		
		# Вызываем команду через фабрику
		DialogueCommandFactory.run_command(tag_content) 
		
		# Очищаем текст от технического тега для вывода игроку
		clean_text = text.replace("[trigger:" + tag_content + "]", "")
		
	$DialogueLabel.text = clean_text

func _on_choice_selected(next_node_id, condition, quest):
	get_item(condition)
	track_quest(quest)
	if next_node_id != null:
		display_line(next_node_id)
	else:
		end_dialogue()

func track_quest(quest_list):
	if quest_list != null:
		for quest in quest_list:
			QuestManager.track_quest(quest)
			
func get_item(condition):
	for i in condition:
		if i.item_given != null:
			InventoryManager.add_item(i.item_given)
			InventoryManager.remove_item(i.item, i.item_quantity)
	
func end_dialogue():
	GameManager.current_game_state = GameManager.GameState.DEFAULT
	GameManager.current_game_camera = GameManager.player_camera
