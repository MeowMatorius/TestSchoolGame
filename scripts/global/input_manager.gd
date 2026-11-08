extends Node

var is_in_choice_menu
var _choice_menu_callback: Callable  = func(flag: bool): is_in_choice_menu = flag


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.entered_choice_menu.connect(_choice_menu_callback)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo(): return

	if GameManager.is_in_dialogue:
		_handle_skip(event)
	else:
		_handle_interact(event)

	if GameManager.is_choosing_item:
		_handle_cancel(event)
	else:
		_handle_pause(event)


func set_input_enabled(enabled: bool):
	set_process_unhandled_input(enabled)


func get_action_button_name(action_name: String) -> String:
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.size() > 0:
		return events[0].as_text().replace(" (Physical)", "") 
	return "None"


func _handle_interact(event: InputEvent):
	if event.is_action_pressed("interact"):
		SignalBus.interaction_pressed.emit()
		get_viewport().set_input_as_handled()


func _handle_skip(event: InputEvent):
	if event.is_action_pressed("skip"):
		SignalBus.skip_pressed.emit()
		get_viewport().set_input_as_handled()


func _handle_pause(event: InputEvent):
	if event.is_action_pressed("pause"):
		SignalBus.pause_pressed.emit()
		get_viewport().set_input_as_handled()


func _handle_cancel(event: InputEvent):
	if event.is_action_pressed("ui_close_dialog") or event.is_action_pressed("ui_cancel"):
		SignalBus.cancel_pressed.emit()
		get_viewport().set_input_as_handled()


func _exit_tree() -> void:
	if SignalBus.entered_choice_menu.is_connected(_choice_menu_callback):
		SignalBus.entered_choice_menu.disconnect(_choice_menu_callback)
