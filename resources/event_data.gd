class_name EventData
extends Resource

@export var event_id: String = "0001"
@export var event_name: String = "EventName"
@export var triggered: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		if triggered == value:
			return
		triggered = value
		emit_changed() # Полезно для ресурсов, чтобы уведомить систему
		if self.triggered == true:
			SignalBus.changed_quest_status.emit(self)

@export var event_start: bool = false
@export var event_over: bool = false
@export var next_event_data: EventData

@export var condition: Array[ConditionData] = []

func _init() -> void:
	# Подключаем глобальный сигнал к функции внутри этого ресурса
#	SignalBus.is_picking.connect(_add_item)
	if not SignalBus.changed_condition_status.is_connected(is_triggered):
		SignalBus.changed_condition_status.connect(is_triggered)
		
func is_triggered(_sender: Variant = null) -> bool:
	return false
#	print(self.id, self.completed)
#	if self.completed == false:
#		self.completed = subquest.all(func(subq): return subq.completed) and condition.all(func(c): return c.completed)		
#	return self.completed	
# Уже выполнено — дальше не проверяем (идемпотентность + не спамим сеттером)
#	if completed:
#		return true
#
#	var has_subquests  := not subquest.is_empty()
#	var has_conditions := not condition.is_empty()
#
#	# Случай «пустого» квеста — решается флагом, а НЕ all()
#	if not has_subquests and not has_conditions:
#		completed = auto_complete
#		return completed
#
#	# Обычный случай: должны быть выполнены и все подквесты, и все condition.
#	# Пустой массив в соответствующей части даст all() == true — это то, что нужно.
#	var subs_done  := subquest.all(func(s): return s.completed)
#	var conds_done := condition.all(func(c): return c.completed)
#
#	completed = subs_done and conds_done
#	return completed