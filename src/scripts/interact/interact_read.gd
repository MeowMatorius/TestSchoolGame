extends Interact

@export var prompt_text: String
@export var noteScene: PackedScene


func interact(object):
	SignalBus.is_reading_note.emit()
	GameManager.current_game_state = GameManager.GameState.READING
	load_note()


func get_prompt() -> String:
	return "Прочесть"


func load_note() -> void:
	var noteTest: Node = noteScene.instantiate()
	add_child(noteTest)