class_name QuestData
extends Resource


@export var id: String = get_id()
@export var name: String = "Квест 1"
@export_multiline var description: = "Описание"
@export var condition: Array[ConditionType] = []


func get_id() -> String:
	# Вернет имя файла без расширения (например, "kill_rats_01")
	return resource_path.get_file().get_basename()
	
	
# Попробуйте так (самый стабильный вариант для Godot 4):
func is_complete() -> bool:
	return condition.all(func(cond): return cond.completed)
