extends Node

var all_dialogues = {} # Здесь храним весь файл
var current_dialogue_key = ""
var dialogue_data = []
var current_step = 0
var path: String

func _ready() -> void:
	SignalBus.is_talking.connect(load_all_data)

func load_all_data(internal_name, dialogue_stage):
	path = "res://jsons/"+internal_name+".json"
	print("path:", path)
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	all_dialogues = JSON.parse_string(content)
	start_dialogue(dialogue_stage)

func start_dialogue(dialogue_stage: String):
	if all_dialogues.has(dialogue_stage):
		current_dialogue_key = dialogue_stage
		show_step()
	else:
		print("Диалог не найден:", dialogue_stage)

func show_step():
	# Берем массив по ключу и из него нужную строку по индексу
	var line = all_dialogues[current_dialogue_key][current_step]["text"]
	current_step+=1
	print(line)
