class_name QuestData
extends Resource

var id: String = get_id()
@export var name: String = "Квест 1"
@export_multiline var description: String = "Описание"
@export var subquest: Array[SubquestData] = []
@export var condition: Array[ConditionData] = []
@export var auto_complete: bool = false

@export var completed: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		if completed == value:
			return
		completed = value
		emit_changed() # Полезно для ресурсов, чтобы уведомить систему
		if self.completed == true:
			SignalBus.changed_quest_status.emit(self)

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
#	print(self.id, self.completed)
#	if self.completed == false:
#		self.completed = subquest.all(func(subq): return subq.completed) and condition.all(func(c): return c.completed)		
#	return self.completed	
# Уже выполнено — дальше не проверяем (идемпотентность + не спамим сеттером)
	if completed:
		return true

	var has_subquests  := not subquest.is_empty()
	var has_conditions := not condition.is_empty()

	# Случай «пустого» квеста — решается флагом, а НЕ all()
	if not has_subquests and not has_conditions:
		completed = auto_complete
		return completed

	# Обычный случай: должны быть выполнены и все подквесты, и все condition.
	# Пустой массив в соответствующей части даст all() == true — это то, что нужно.
	var subs_done  := subquest.all(func(s): return s.completed)
	var conds_done := condition.all(func(c): return c.completed)

	completed = subs_done and conds_done
	return completed

func _init() -> void:
	# Подключаем глобальный сигнал к функции внутри этого ресурса
#	SignalBus.is_picking.connect(_add_item)

	if not SignalBus.changed_subquest_status.is_connected(is_complete):
		SignalBus.changed_subquest_status.connect(is_complete)
		
	if not SignalBus.changed_condition_status.is_connected(is_complete):
		SignalBus.changed_condition_status.connect(is_complete)