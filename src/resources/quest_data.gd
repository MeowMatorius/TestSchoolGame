class_name QuestData
extends Resource

@export var id: String = get_id()
@export var name: String = "Квест 1"
@export_multiline var description = "Описание"
@export var subquest: Array[SubquestData] = []

@export var completed: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		completed = value
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

func is_complete(iii) -> bool:
	
	self.completed = subquest.all(func(subq): return subq.completed)
	if self.completed == true:
		SignalBus.changed_quest_status.emit(self)
	return self.completed
	
func _init() -> void:
	# Подключаем глобальный сигнал к функции внутри этого ресурса
#	SignalBus.is_picking.connect(_add_item)


	if not SignalBus.changed_subquest_status.is_connected(is_complete):
		SignalBus.changed_subquest_status.connect(is_complete)