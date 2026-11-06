class_name CommandFactory
extends RefCounted

enum CommandType { NONE, START_QUEST, END_QUEST, PLAYER_GIVES_ITEM, PLAYER_GETS_ITEM, PLAYER_EXCHANGES_ITEM, REFRESH_DIALOGUES }


static func create_command(type: CommandType, command_component: Resource = null) -> Command:
	match type:
		CommandType.START_QUEST:
			if command_component.quest is QuestData:
				return CommandQuestAccept.new(command_component.quest)
			push_error("Фабрика: Для команды START_QUEST нужен QuestResource!")
		CommandType.NONE:
			pass
		CommandType.END_QUEST:
			if command_component.quest is QuestData:
				return CommandQuestComplete.new(command_component.quest)
			push_error("Фабрика: Для команды END_QUEST нужен QuestResource!")
		CommandType.PLAYER_GETS_ITEM:
			if command_component.reward_item is ItemData:
				return CommandItemGet.new(command_component.reward_item)
			push_error("Фабрика: Для команды PLAYER_GETS_ITEM нужен ItemResource!")
		CommandType.PLAYER_GIVES_ITEM:
			if command_component.required_item is ItemData:
				return CommandItemGive.new(command_component.required_item, command_component.required_quantity)
			push_error("Фабрика: Для команды PLAYER_GIVES_ITEM нужен ItemResource!")
		CommandType.PLAYER_EXCHANGES_ITEM:
			if command_component.required_item is ItemData and command_component.reward_item is ItemData:
				return CommandItemExchange.new(command_component.reward_item, command_component.required_item, command_component.required_quantity)
			push_error("Фабрика: Для команды PLAYER_EXCHANGES_ITEM нужен ItemResource!")
		CommandType.REFRESH_DIALOGUES:
			if command_component.dialogue is DialogueData:
				return CommandDialogueRefresh.new(command_component.dialogue)
			push_error("Фабрика: Для команды REFRESH_DIALOGUES нужен DialogueData!")
	#		CommandType.END_QUEST:
#			if data.quest is QuestData:
#				return CompleteQuestCommand.new(data.quest)
#			push_error("Фабрика: Для команды END_QUEST нужен QuestResource!")
	return null
