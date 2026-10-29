# Сабквесты всегда входят в состав основного квеста
# Для отслеживания их выполнения - используем condition. Как только выполнены все condition из списка - выполнен и подквест
# completed должен изменяться на true когда будут выполнены все condition
# нужно проверять все ли condition в статусе = true

class_name SubquestData
extends Resource

@export var id: String = get_id()
@export var name: String = "Квест 1"
@export_multiline var description: = "Описание"
@export var condition: Array[ConditionData] = []

@export var completed: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		completed = value
		print("completed для ", self, "изменено на: ", completed)
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
#	for cond in condition:
#		if not cond.completed:
#			return false
#	return true
	self.completed = condition.all(func(cond): return cond.completed)
	if self.completed == true:
		SignalBus.changed_subquest_status.emit(self)
	return self.completed


func _init() -> void:
	# Подключаем глобальный сигнал к функции внутри этого ресурса
#	SignalBus.is_picking.connect(_add_item)


	if not SignalBus.changed_condition_status.is_connected(is_complete):
		SignalBus.changed_condition_status.connect(is_complete)

