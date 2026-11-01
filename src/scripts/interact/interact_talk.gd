extends Interact

@export var npc_data: NpcData


func _ready() -> void:
	object_type = ObjectType.TALK


func interact(_target_object):
	trigger_command()
	
	SignalBus.is_talking.emit(npc_data)


func get_prompt() -> String:
	return "Поговорить"

