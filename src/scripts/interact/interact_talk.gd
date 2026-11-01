extends Interact

@export var npc_data: NpcData


func _ready() -> void:
	super._ready()
	object_type = ObjectType.TALK


func interact(_target_object):
	SignalBus.is_talking.emit(npc_data)
	trigger_commands()


func get_prompt() -> String:
	return "Поговорить"

