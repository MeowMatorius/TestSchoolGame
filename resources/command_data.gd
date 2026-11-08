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
@export var required_item: ItemData # Что отдаем
@export var required_quantity: int = 1
@export var reward_item: ItemData # Что получаем
@export var quest: QuestData
@export var event: EventData
@export var dialogue: DialogueData

# Отображение требований для замка ЕСЛИ закрыто
func _validate_property(property: Dictionary) -> void:
	if command_type == CommandFactory.CommandType.PLAYER_GETS_ITEM:
		match property.name:
			"quest", "event", "required_item", "required_quantity", "dialogue":
				property.usage = PROPERTY_USAGE_NO_EDITOR
	elif command_type == CommandFactory.CommandType.PLAYER_GIVES_ITEM:
		match property.name:
			"quest", "event", "reward_item", "dialogue":
				property.usage = PROPERTY_USAGE_NO_EDITOR
	elif command_type == CommandFactory.CommandType.PLAYER_EXCHANGES_ITEM:
		match property.name:
			"quest", "event", "dialogue":
				property.usage = PROPERTY_USAGE_NO_EDITOR
	elif command_type == CommandFactory.CommandType.END_QUEST or command_type == CommandFactory.CommandType.START_QUEST:
		match property.name:
			"event", "required_item", "required_quantity", "reward_item", "dialogue":
				property.usage = PROPERTY_USAGE_NO_EDITOR
	elif command_type == CommandFactory.CommandType.REFRESH_DIALOGUES:
		match property.name:
			"quest", "event", "required_item", "required_quantity", "reward_item":
				property.usage = PROPERTY_USAGE_NO_EDITOR