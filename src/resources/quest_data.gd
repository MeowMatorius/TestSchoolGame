class_name QuestData
extends Resource

@export var id: String = get_id()
@export var name: String = "Квест 1"
@export_multiline var description: = "Описание"
@export var condition: Array[ConditionData] = []
@export var subquest: Array[QuestData] = []

@export var completed: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		completed = value
		print("completed изменено на: ", completed)
		emit_changed() # Полезно для ресурсов, чтобы уведомить систему
		SignalBus.quest_completed.emit(self)

@export var failed: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		failed = value
		print("failed изменено на: ", failed)
		emit_changed() # Полезно для ресурсов, чтобы уведомить систему
		SignalBus.quest_completed.emit(self)


func get_id() -> String:
	# Вернет имя файла без расширения (например, "kill_rats_01")
	return resource_path.get_file().get_basename()


func is_complete() -> bool:
	return condition.all(func(cond): return cond.completed)
