#TODO 1. Если нет condition квест и сабквест сразу считают себя выполненными
#TODO UI обновляется по разному? Во вкладке "задания" отображается корректно, в самой игре обновляется с задержкой

extends Node
var active_quests: Array[QuestData] = []
var active_subquests: Array[SubquestData] = []

var completed_quests: Array[QuestData] = []

func _ready() -> void:
	SignalBus.start_quest.connect(start_quest)


func start_quest(quest):
	for j in quest:
		print(j.description)


# Регистрация квеста в системе
func track_quest(quest: QuestData):
	if not active_quests.has(quest):
		active_quests.append(quest)
		
		SignalBus.started_quest.emit(quest)
		_call_command_factory(quest)
		quest.is_complete()
#		print("Квест добавлен в список")
#		print(active_quests)

		# Подписываемся на каждое условие этого квеста
#		if quest.subquest != null:
#			for subquest in quest.subquest:
#				if not active_subquests.has(subquest) and subquest.completed == false:
#					active_subquests.append(subquest)
#				for condition in subquest.condition:
#					print(condition, condition.completed)


func _complete_quest(quest: QuestData):
	print("Квест выполнен: ", quest.name)
	if quest in active_quests:
		quest.completed = true
		completed_quests.append(quest)
		active_quests.erase(quest)
#		print('активные квесты ', active_quests)
#		print('завершенные квесты ', completed_quests)

func _call_command_factory(quest_data) -> void:

	for i in quest_data.commands:
	# Фабрика создает команду, используя тип из ресурса и прикрепленный квест
		var command := CommandFactory.create_command(i.command_type, i)
		
		if command:
			command.execute(get_tree())