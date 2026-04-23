extends Node

var all_dialogues: Dictionary[Variant, Variant] = {} # Здесь храним весь файл
var current_dialogue_key: String = ""
var dialogue_data: Array[Variant] = []
var current_step: int = 0
var path: String

signal is_skiping
signal started_talking
signal stoped_talking

func _ready() -> void:
	SignalBus.is_talking.connect(load_all_data)


func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("skip") and GameManager.current_game_state == GameManager.game_state.Mouse:
		is_skiping.emit()
		get_viewport().set_input_as_handled()


func load_all_data(internal_name, dialogue_stage):
	path = "res://jsons/"+internal_name+".json"
	print("path:", path)
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	all_dialogues = JSON.parse_string(content)
	start_dialogue(dialogue_stage)


func start_dialogue(dialogue_stage: String):
	GameManager.current_game_state = GameManager.game_state.Mouse
	GameManager.mouse_input_mode_switch()
	if all_dialogues.has(dialogue_stage):
		for i in range(all_dialogues[dialogue_stage].size()):
			if i != 0:
				await is_skiping
			var speaker = all_dialogues[dialogue_stage][i]["name"]
			var line = all_dialogues[dialogue_stage][i]["text"]
			print(speaker, ": ", line)
			started_talking.emit(speaker, line)
		await is_skiping
	else:
		print("Диалог не найден:", dialogue_stage)
	stoped_talking.emit()
	GameManager.current_game_state = GameManager.game_state.Default
	GameManager.mouse_input_mode_switch()