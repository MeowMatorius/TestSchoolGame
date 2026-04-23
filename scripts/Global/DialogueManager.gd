extends Node

var all_dialogues: Dictionary[Variant, Variant] = {} # Здесь храним весь файл
var current_dialogue_key: String = ""
var dialogue_data: Array[Variant] = []
var current_step: int = 0
var path: String

signal is_skiping

func _ready() -> void:
	SignalBus.is_talking.connect(load_all_data)


func _process(delta: float) -> void:
	handle_skip()


func load_all_data(internal_name, dialogue_stage):
	path = "res://jsons/"+internal_name+".json"
	print("path:", path)
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	all_dialogues = JSON.parse_string(content)
	start_dialogue(dialogue_stage)

#сейчас диалог каждый раз проигрывается по нажатию кнопки действия. 
#Просто запоминается текущая реплика
#Надо сделать переход в режим диалога и по кнопке переключать реплики в цилке for
func start_dialogue(dialogue_stage: String):
	GameManager.current_game_state = GameManager.game_state.Mouse
	GameManager.mouse_input_mode_switch()
	if all_dialogues.has(dialogue_stage):
		for i in range(all_dialogues[dialogue_stage].size()):
			print(i)
			await is_skiping
			var line = all_dialogues[dialogue_stage][i]["text"]
			print(line)	
	else:
		print("Диалог не найден:", dialogue_stage)
	GameManager.current_game_state = GameManager.game_state.Default
	GameManager.mouse_input_mode_switch()

#func show_step():
	## Берем массив по ключу и из него нужную строку по индексу
	#var line = all_dialogues[current_dialogue_key][current_step]["text"]
	#current_step+=1
	#print(line)

func handle_skip():
	if Input.is_action_just_pressed("skip") and GameManager.current_game_state != GameManager.game_state.Pause:
		is_skiping.emit()
		
