extends Interact

@export var internal_name: String = "NPC"
@export var dialogue_stage: String = "dialogue_1"


func _ready() -> void:
	highlighted = false
	pass


func interact(object):
	SignalBus.is_talking.emit(internal_name, dialogue_stage)


func get_prompt() -> String:
	return "Поговорить"