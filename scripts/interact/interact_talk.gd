extends Interact

@export var npc_data: NpcData
@export var commands: Array[CommandData]


func _ready() -> void:
	super._ready()
	object_type = ObjectType.TALK


func interact(_target_object):
	SignalBus.is_talking.emit(npc_data)
	trigger_enter_commands(commands)


func get_prompt() -> String:
	return "Поговорить"

