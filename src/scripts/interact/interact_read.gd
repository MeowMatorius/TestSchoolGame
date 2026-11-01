extends Interact

@export var prompt_text: String
@export var noteScene: PackedScene


func _ready():
	super._ready()
	object_type = ObjectType.READ

func interact(_target_object):
	GameManager.current_game_state = GameManager.GameState.READING
	load_note()

	trigger_commands()


func get_prompt() -> String:
	return ' ' + prompt_text


func load_note() -> void:
	SignalBus.is_reading.emit()
	var noteNode: Node = noteScene.instantiate()
	add_child(noteNode)
