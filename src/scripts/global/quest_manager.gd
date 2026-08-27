extends Node
var active_quests: Array[QuestData] = []
var active_subquests: Array[SubquestData] = []

signal started_quest
signal stoped_quest


func _ready() -> void:
	DialogueManager.start_quest.connect(start_quest)


func start_quest(quest):
	for j in quest:
		print(j.description)


# Регистрация квеста в системе
func track_quest(quest: QuestData):
	if not active_quests.has(quest) and quest.completed == false:
		active_quests.append(quest)
		started_quest.emit(quest)
		print("Квест добавлен в список")
		print(active_quests)
		# Подписываемся на каждое условие этого квеста
		if quest.subquest != null:
			for subquest in quest.subquest:
				if not active_subquests.has(subquest) and subquest.completed == false:
					active_subquests.append(subquest)
				for condition in subquest.condition:
					if not condition.is_connected("changed_status", _on_condition_updated):
						condition.changed_status.connect(_on_condition_updated)
#		if quest.condition != null:
#			for condition in quest.condition:
#				if not condition.is_connected("changed_status", _on_condition_updated):
#					condition.changed_status.connect(_on_condition_updated)
			


func _on_condition_updated(condition: ConditionData):
	print("Условие изменилось: ", condition.completed)
	
	# Проверяем все квесты, которые зависят от этого условия
	for quest in active_quests:
		for subquest in quest.subquest:
			if subquest.condition.has(condition):
			# Выполняет ф-ю из subquest_data для проверки статусов всех условий
				if subquest.is_complete():
					_complete_subquest(subquest)
					
func _complete_subquest(subquest: SubquestData):
	subquest.completed = true
	print("Подвест выполнен: ", subquest.name)
	for quest in active_quests:
		if quest.subquest.has(subquest):
		# Выполняет ф-ю из subquest_data для проверки статусов всех условий
			if quest.is_complete():
				_complete_quest(quest)

func _complete_quest(quest: QuestData):
	print("Квест выполнен: ", quest.name)
	quest.completed = true

	# Здесь можно выдать награду или удалить из списка активных
#	if subquest in active_quests:
#		active_quests.erase(subquest)
#		stoped_quest.emit(subquest)
