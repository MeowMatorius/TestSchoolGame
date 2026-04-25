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
		start_dialogue_choice(dialogue_stage)
	else:
		print("Диалоги закончились")


func start_dialogue_choice(dialogue_stage):
	
	choices_array = []
	GameManager.current_game_state = GameManager.GameState.DIALOGUE
	var dialogue_id = all_dialogues[dialogue_stage]
	var speaker = dialogue_id["speaker"]
	var text = dialogue_id["text"]
	var choices = dialogue_id["choices"]
	
	for i in range(text.size()):
		if i != 0:
			await InputManager.skip_pressed
		var line = text[i]
		started_talking.emit(speaker, line)

		if i+1 == text.size():
			for j in range(choices.size()):
				choices_array.append(choices[j]["text"])
			if choices_array.size() >= 1:
				print("Да, я отправил ", choices)
				start_choosing.emit(choices)
			elif choices_array.size() == 0:
				pass
	await InputManager.skip_pressed
	
	stoped_talking.emit()
	GameManager.current_game_state = GameManager.GameState.DEFAULT
#	switch_dialogue_stage(dialogue_stage, internal_name)
			
func _on_choice_selected(next_node_id):
	start_dialogue_choice(next_node_id)
	print("Игрок выбрал путь: ", next_node_id)			
	
	
func switch_dialogue_stage(dialogue_stage, internal_name):
	var get_next_dialogue_stage = dialogue_stage.split("_")[0] + "_" + str(int(dialogue_stage.split("_")[-1]) + 1)
	next_dialogue_stage.emit(get_next_dialogue_stage, internal_name)
	
