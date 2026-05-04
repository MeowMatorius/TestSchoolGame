class_name QuestData
extends Resource


@export var name: String = "Квест 1"
@export_multiline var description: = "Описание"
@export var condition: Array[ConditionType] = []


# Попробуйте так (самый стабильный вариант для Godot 4):
func is_complete() -> bool:
	return condition.all(func(cond): return cond.completed)
