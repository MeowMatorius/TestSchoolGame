#TODO 1. Если нет condition квест и сабквест сразу считают себя выполненными
#TODO UI обновляется по разному? Во вкладке "задания" отображается корректно, в самой игре обновляется с задержкой

extends Node
var active_quests: Array[QuestData] = []
var active_subquests: Array[SubquestData] = []


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
		quest.is_complete(null)
		print("Квест добавлен в список")
		print(active_quests)
		# Подписываемся на каждое условие этого квеста
		if quest.subquest != null:
			for subquest in quest.subquest:
				if not active_subquests.has(subquest) and subquest.completed == false:
					active_subquests.append(subquest)
				for condition in subquest.condition:
					print(condition, condition.completed)


func _complete_quest(quest: QuestData):
	print("Квест выполнен: ", quest.name)
	quest.completed = true

