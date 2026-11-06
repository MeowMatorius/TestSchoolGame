class_name SignalUtilities
extends RefCounted


## Подключение одного сигнала (если еще не подключен)
static func connect_signal(signal_name: Signal, func_name: Callable, flags: int = 0) -> void:
	if not signal_name.is_connected(func_name):
		signal_name.connect(func_name, flags)


## Отключение одного сигнала (если подключен)
static func disconnect_signal(signal_name: Signal, func_name: Callable) -> void:
	if signal_name.is_connected(func_name):
		signal_name.disconnect(func_name)


## Переключение одного сигнала
static func toggle_signal(signal_name: Signal, func_name: Callable, enable: bool, flags: int = 0) -> void:
	if enable:
		connect_signal(signal_name, func_name, flags)
	else:
		disconnect_signal(signal_name, func_name)


#  Пример:
#	func _signal_pairs() -> Array:
#		return [
# 			[SignalBus.cancel_pressed, _close],
# 			[SignalBus.pause_pressed, _close],
# 		]
## Подключение нескольких сигналов
## pairs массив [Signal, Callable] или [Signal, Callable, flags]
static func connect_all(pairs: Array) -> void:
	for pair in pairs:
		_apply(pair, true)


## Отключение нескольких сигналов
static func disconnect_all(pairs: Array) -> void:
	for pair in pairs:
		_apply(pair, false)


## Переключение нескольких сигналов одним флагом
static func toggle_all(pairs: Array, enable: bool) -> void:
	for pair in pairs:
		_apply(pair, enable)


## Распаковка пары и применение (Внутренняя функция)
static func _apply(pair: Array, enable: bool) -> void:
	var signal_name: Signal = pair[0]
	var func_name: Callable = pair[1]
	var flags: int = pair[2] if pair.size() > 2 else 0
	if enable:
		connect_signal(signal_name, func_name, flags)
	else:
		disconnect_signal(signal_name, func_name)
