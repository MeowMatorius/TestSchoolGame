extends Interact

@export var dialogue_camera: PhantomCamera3D
@export var player_teleport_point: Node3D
@export var npc_data: NPCData


func interact(object):
	SignalBus.is_talking.emit(npc_data)


func get_prompt() -> String:
	return "Поговорить"

