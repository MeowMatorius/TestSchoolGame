class_name SwitchData
extends Resource

enum ObjectState {ON, OFF}
@export var object_state: ObjectState = ObjectState.OFF

## Одноразовое использование (Activate)
@export var one_time_use: bool = false

@export_enum("Включить", "Открыть", "Вытащить") var activate_prompt_message: String = "Открыть"
@export_enum("Выключить", "Закрыть", "Убрать") var deactivate_prompt_message: String = "Закрыть"

@export_category("Настройка замка")
enum LockState {LOCKED, UNLOCKED, BROKEN}
@export var lock_state: LockState = LockState.UNLOCKED
@export var item_needed_to_open: ItemData
@export var quantity_needed_to_open: int