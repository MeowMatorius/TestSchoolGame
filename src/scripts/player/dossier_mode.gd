extends Control


func _ready() -> void:
	SignalBus.dossier_requested.connect(dossier_mode)


func dossier_mode():
	pass
	#GameManager.current_game_state = GameManager.GameState.DOSSIER
