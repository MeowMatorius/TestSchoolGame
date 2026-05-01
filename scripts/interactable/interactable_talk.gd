extends Interactable

@export var internal_name: String = "NPC"
@export var dialogue_stage: String = "dialogue_1"
@export var dialogue_camera: PhantomCamera3D
@export var player_teleport_point: Node3D
@export var dialogue: DialogueLine


func _ready() -> void:
	highlighted = false
#	DialogueManager.next_dialogue_stage.connect(change_dialogue_stage)



func interact(object):
	print("интерактнул жоска")
	print(dialogue)
	SignalBus.is_talking.emit(internal_name, dialogue_stage, dialogue_camera, dialogue)


func get_prompt() -> String:
	return "Поговорить"
	
	
func change_dialogue_stage(dialogue_id, npc_name):
	if internal_name == npc_name:
		dialogue_stage = dialogue_id
