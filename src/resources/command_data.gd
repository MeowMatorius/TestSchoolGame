@tool
class_name CommandData
extends Resource

@export var command_name: String = "Command"

@export var command_type: CommandFactory.CommandType = CommandFactory.CommandType.NONE:
	set(value):
		if command_type == value:
			return
		command_type = value
		notify_property_list_changed()
		emit_changed()
@export var item: ItemData
@export var quest: QuestData
@export var event: EventData

# Отображение требований для замка ЕСЛИ закрыто
func _validate_property(property: Dictionary) -> void:
	if command_type == CommandFactory.CommandType.GIVE_ITEM:
		match property.name:
			"quest", "event":
				property.usage = PROPERTY_USAGE_NO_EDITOR
	elif command_type == CommandFactory.CommandType.END_QUEST or command_type == CommandFactory.CommandType.START_QUEST:
		match property.name:
			"item", "event":
				property.usage = PROPERTY_USAGE_NO_EDITOR