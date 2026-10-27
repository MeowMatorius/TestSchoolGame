class_name CommandData
extends Resource

@export var command_name: String = "Command"

@export var command_type: CommandFactory.CommandType = CommandFactory.CommandType.NONE
@export var item: ItemData
@export var quest: QuestData
@export var event: EventData