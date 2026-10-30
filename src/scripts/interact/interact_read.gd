extends Interact

@export var prompt_text: String
@export var noteScene: PackedScene


func interact(_target_object):
	GameManager.current_game_state = GameManager.GameState.READING
	load_note()


func get_prompt() -> String:
	return 'Прочесть: ' + prompt_text
	#return 'Прочесть: ' + prompt_text


func load_note() -> void:
	SignalBus.is_reading.emit()
	var noteNode: Node = noteScene.instantiate()
	add_child(noteNode)
