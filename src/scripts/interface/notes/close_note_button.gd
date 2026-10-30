extends Button

func _on_pressed() -> void:
	GameManager.current_game_state = GameManager.GameState.DEFAULT
	SignalBus.is_stopped_reading.emit()
	get_parent().queue_free()
