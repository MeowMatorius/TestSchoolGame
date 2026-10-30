extends Button

@export var item_use_menu: GridContainer

func _on_button_up() -> void:
	item_use_menu.clear_slots()
	GameManager.current_game_state = GameManager.GameState.DEFAULT

func hide_button():
	visible = false