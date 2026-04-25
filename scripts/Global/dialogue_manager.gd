extends Node

var all_dialogues: Dictionary[Variant, Variant] = {} # Здесь храним весь файл
var current_dialogue_key: String = ""
var dialogue_data: Array[Variant] = []
var current_step: int = 0
var path: String
var choices_array: Array[Variant] = []

signal started_talking
signal stoped_talking
signal start_choosing
signal next_dialogue_stage


func _ready() -> void:
	SignalBus.is_talking.connect(load_all_data)


func load_all_data(internal_name, dialogue_stage):
	path = "res://jsons/"+internal_name+".json"
	print("path:", path)
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	all_dialogues = JSON.parse_string(content)
	
	if all_dialogues.has(dialogue_stage):
#		start_dialogue(dialogue_stage, internal_name)
		start_dialogue_choice(dialogue_stage, internal_name)
	else:
		print("Диалоги закончились")


func start_dialogue_choice(dialogue_stage, internal_name):
	GameManager.current_game_state = GameManager.GameState.DIALOGUE
	
	for i in range(all_dialogues[dialogue_stage]["text"].size()):
		if i != 0:
			await InputManager.skip_pressed
		var speaker = all_dialogues[dialogue_stage]["speaker"]
		var line = all_dialogues[dialogue_stage]["text"][i]
		started_talking.emit(speaker, line)
		
		if i+1 == all_dialogues[dialogue_stage]["text"].size():
			for j in range(all_dialogues[dialogue_stage]["choices"].size()):
				choices_array.append(all_dialogues[dialogue_stage]["choices"][j]["text"])
			start_choosing.emit(choices_array)
	await InputManager.skip_pressed
	
	stoped_talking.emit()
	GameManager.current_game_state = GameManager.GameState.DEFAULT
#	switch_dialogue_stage(dialogue_stage, internal_name)
				
				
func start_dialogue(dialogue_stage: String, internal_name):
	GameManager.current_game_state = GameManager.GameState.DIALOGUE
	GameManager.mouse_input_mode_switch()
	
	for i in range(all_dialogues[dialogue_stage].size()):
		if i != 0:
			await InputManager.skip_pressed
		var speaker = all_dialogues[dialogue_stage][i]["name"]
		var line = all_dialogues[dialogue_stage][i]["text"]
		print(speaker, ": ", line)
		started_talking.emit(speaker, line)
	await InputManager.skip_pressed
	
	stoped_talking.emit()
	GameManager.current_game_state = GameManager.GameState.DEFAULT
	GameManager.mouse_input_mode_switch()
	switch_dialogue_stage(dialogue_stage, internal_name)
	
	
func switch_dialogue_stage(dialogue_stage, internal_name):
	var get_next_dialogue_stage = dialogue_stage.split("_")[0] + "_" + str(int(dialogue_stage.split("_")[-1]) + 1)
	next_dialogue_stage.emit(get_next_dialogue_stage, internal_name)
	
