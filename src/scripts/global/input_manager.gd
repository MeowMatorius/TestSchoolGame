extends Node

var is_in_choice_menu
var _choice_menu_callback: Callable  = func(state: bool): is_in_choice_menu = state

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.entered_choice_menu.connect(_choice_menu_callback)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo(): return

	var state: GameManager.GameState = GameManager.current_game_state
	match state:
		GameManager.GameState.DEFAULT:
			get_action_pause(event)
			get_action_interact(event)
		GameManager.GameState.DIALOGUE:
			get_action_pause(event)
			get_action_skip(event)
		GameManager.GameState.READING:
			get_action_cancel(event)
		GameManager.GameState.USING_ITEM:
			get_action_cancel(event)
		GameManager.GameState.PAUSE:
			get_action_pause(event)
		_:
			pass
			

func set_input_enabled(enabled: bool):
	set_process_unhandled_input(enabled)


func get_action_button_name(action_name: String) -> String:
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.size() > 0:
		return events[0].as_text().replace(" (Physical)", "") 
	return "None"


func get_action_interact(event: InputEvent):
	if event.is_action_pressed("interact"):
		SignalBus.interaction_pressed.emit()
		get_viewport().set_input_as_handled()


func get_action_skip(event: InputEvent):
	if event.is_action_pressed("skip"):
		SignalBus.skip_pressed.emit()
		get_viewport().set_input_as_handled()


func get_action_pause(event: InputEvent):
	if event.is_action_pressed("pause"):
		SignalBus.pause_pressed.emit()
		get_viewport().set_input_as_handled()


func get_action_cancel(event: InputEvent):
	if event.is_action_pressed("ui_close_dialog") or event.is_action_pressed("ui_cancel"):
		SignalBus.cancel_pressed.emit()
		get_viewport().set_input_as_handled()


func _exit_tree() -> void:
	if SignalBus.entered_choice_menu.is_connected(_choice_menu_callback):
		SignalBus.entered_choice_menu.disconnect(_choice_menu_callback)
