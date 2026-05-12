extends Interact

@export var read_data: NoteData
@export var node: Node

func interact(object):
	SignalBus.is_reading.emit(read_data)


func get_prompt() -> String:
	return "Читать"
