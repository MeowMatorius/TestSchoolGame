@tool
class_name SwitchData
extends Resource

enum ObjectState {ON, OFF}
@export var object_state: ObjectState = ObjectState.OFF

## Одноразовое использование (Activate)
@export var one_time_use: bool = false

@export_enum("Включить", "Открыть", "Вытащить") var activate_prompt_message: String = "Открыть"
@export_enum("Выключить", "Закрыть", "Убрать") var deactivate_prompt_message: String = "Закрыть"


# Настройки замка
enum LockState {LOCKED, UNLOCKED, BROKEN}
@export_category("Настройка замка")
@export var lock_state: LockState = LockState.UNLOCKED:
	set(value):
		if lock_state == value:
			return
		lock_state = value
		notify_property_list_changed()
		emit_changed()

@export var item_needed_to_open: ItemData
@export_range(1, 999) var quantity_needed_to_open: int = 1

# Отображение требований для замка ЕСЛИ закрыто
func _validate_property(property: Dictionary) -> void:
	if lock_state != LockState.LOCKED:
		match property.name:
			"item_needed_to_open", "quantity_needed_to_open":
				property.usage = PROPERTY_USAGE_NO_EDITOR