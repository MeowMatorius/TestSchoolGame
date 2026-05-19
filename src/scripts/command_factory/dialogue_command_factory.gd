class_name DialogueCommandFactory
extends RefCounted

enum CommandType { NONE, START_QUEST, END_QUEST, GIVE_ITEM }

static func create_command(type: CommandType, data: Resource = null) -> DialogCommand:
	match type:
		CommandType.START_QUEST:
			if data.start_quest is QuestData:
				return AcceptQuestCommand.new(data.start_quest)
			push_error("Фабрика: Для команды START_QUEST нужен QuestResource!")
		CommandType.END_QUEST:
			if data.end_quest is QuestData:
				return CompleteQuestCommand.new(data.end_quest)
			push_error("Фабрика: Для команды END_QUEST нужен QuestResource!")
			

	return null
