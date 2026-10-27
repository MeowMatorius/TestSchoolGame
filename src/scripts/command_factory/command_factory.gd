class_name CommandFactory
extends RefCounted

enum CommandType { NONE, START_QUEST, END_QUEST, GIVE_ITEM }


static func create_command(type: CommandType, data: Resource = null) -> Command:
	match type:
		CommandType.START_QUEST:
			if data.quest is QuestData:
				return CommandQuestAccept.new(data.quest)
			push_error("Фабрика: Для команды START_QUEST нужен QuestResource!")
		CommandType.NONE:
			pass
		CommandType.END_QUEST:
			pass
		CommandType.GIVE_ITEM:
			pass
	#		CommandType.END_QUEST:
#			if data.quest is QuestData:
#				return CompleteQuestCommand.new(data.quest)
#			push_error("Фабрика: Для команды END_QUEST нужен QuestResource!")
	return null
