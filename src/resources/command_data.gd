class_name CommandData
extends Resource

@export var command_name: String = "Command"

@export var command_type: DialogueCommandFactory.CommandType = DialogueCommandFactory.CommandType.NONE
@export var item: ItemData
@export var quest: QuestData
@export var event: EventData