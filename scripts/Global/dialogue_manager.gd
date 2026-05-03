extends Node

var all_dialogues: Dictionary[Variant, Variant] = {} # Здесь храним весь файл
var current_dialogue_key: String = ""
var dialogue_data: Array[Variant] = []
var current_step: int = 0
var path: String
var choices_array: Array[Variant] = []
var count:int = 0

#@export var dialogue_line: DialogueLine
#@export var dialogue_choice: DialogueChoice

signal started_talking
signal start_choosing


func _ready() -> void:
	SignalBus.is_talking.connect(enter_dialogue_state)
	
func enter_dialogue_state(internal_name, dialogue_stage, dialogue_camera, dialogue_line: DialogueLine):
	
	GameManager.current_game_state = GameManager.GameState.DIALOGUE
	GameManager.current_game_camera = dialogue_camera
	display_line(dialogue_line)


func display_line(dialogue_line):
	print(dialogue_line, dialogue_line.choices, dialogue_line.text)
	started_talking.emit(dialogue_line.character_name, dialogue_line.text)
	if dialogue_line.choices.size() == 0:
		await InputManager.skip_pressed
	
	if dialogue_line.next_dialogue != null:
		display_line(dialogue_line.next_dialogue)
	elif dialogue_line.choices.size() != 0:
		start_choosing.emit(dialogue_line)
	else:
		GameManager.current_game_state = GameManager.GameState.DEFAULT
		GameManager.current_game_camera = GameManager.player_camera
	

func _on_choice_selected(next_node_id, condition):
	for i in condition:
		if i.item_given != null:
			InventoryManager.add_item(i.item_given)
			InventoryManager.remove_item(i.item.name, i.item_quantity)
	display_line(next_node_id)

#func _on_next_pressed(current_line: DialogueLine):
#	if current_line.next_dialogue:
#		display_line(current_line.next_dialogue)
#	else:
#		hide() # Конец диалога	
	
	
	
	
	
	


#func load_all_data(internal_name, dialogue_stage, dialogue_camera):
#	path = "res://jsons/"+internal_name+".json"
#	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
#	var content: String = file.get_as_text()
#	all_dialogues = JSON.parse_string(content)
#	
#	if all_dialogues.has(dialogue_stage):
#		enter_dialogue_state(dialogue_stage, dialogue_camera)
#
#
#func enter_dialogue_state(dialogue_stage, dialogue_camera):
#	GameManager.current_game_state = GameManager.GameState.DIALOGUE
#	GameManager.current_game_camera = dialogue_camera
#	start_dialogue_choice(dialogue_stage)
#
#
#func start_dialogue_choice(dialogue_stage):
#	choices_array = []
#	var dialogue_id = all_dialogues[dialogue_stage]
#	var speaker = dialogue_id["speaker"]
#	var text = dialogue_id["text"]
#	var choices = dialogue_id["choices"]
#	
#	for i in range(text.size()):
#		if i != 0:
#			await InputManager.skip_pressed
#		var line = text[i]
#		started_talking.emit(speaker, line)
#		if i+1 == text.size():
#			for j in range(choices.size()):
#				choices_array.append(choices[j]["text"])
#			if choices_array.size() >= 1:
#				start_choosing.emit(choices)
#			elif choices.size() == 0:
#				await InputManager.skip_pressed
#				GameManager.current_game_state = GameManager.GameState.DEFAULT
#				GameManager.current_game_camera = GameManager.player_camera
#			
#		
#func _on_choice_selected(next_node_id):
#	start_dialogue_choice(next_node_id)
	
