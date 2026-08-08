extends Button
signal is_stoped_reading_note()

func _on_pressed() -> void:
	GameManager.current_game_state = GameManager.GameState.DEFAULT
	is_stoped_reading_note.emit()
	get_parent().get_parent().queue_free()