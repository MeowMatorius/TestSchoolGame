extends Node

signal pause_requested
signal interaction_pressed
signal skip_pressed

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo(): return

	# Пауза работает во всех Game State
	if event.is_action_pressed("pause"):
		if event.is_action_pressed("pause"):
			pause_requested.emit()
			return

	# Разделение Interact и Skip на разные Game State
	var state = GameManager.current_game_state
	match state:
			GameManager.GameState.DEFAULT:
				if event.is_action_pressed("interact"):
					interaction_pressed.emit()
					
			GameManager.GameState.DIALOGUE:
				if event.is_action_pressed("skip"):
					skip_pressed.emit()


func set_input_enabled(enabled: bool):
	set_process_unhandled_input(enabled)
