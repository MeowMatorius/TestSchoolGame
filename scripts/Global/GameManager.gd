extends Node

enum GameState {DEFAULT, DIALOGUE, PAUSE}

var current_game_state: GameState = GameState.DEFAULT:
	set(value):
		previous_game_state = current_game_state
		current_game_state = value
		_on_game_state_changed()

var previous_game_state: GameState
var state_before_pause: GameState
	
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var player_ui: Control = player.get_node("UserInterface")
@onready var player_ui_pause: Control = player_ui.get_node("PauseMenu")
@onready var player_ui_prompt: Control = player_ui.get_node("Prompt")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	InputManager.pause_requested.connect(_on_pause_requested)


func _on_pause_requested() -> void:
	# Логика переключения состояния
	if current_game_state == GameState.PAUSE:
		current_game_state = state_before_pause
	else:
		state_before_pause = current_game_state
		current_game_state = GameState.PAUSE


func _on_game_state_changed() -> void:
	match current_game_state:
		GameState.DEFAULT:
			_update_game_state(Input.MOUSE_MODE_CAPTURED, false, false, 1.0)
		GameState.DIALOGUE:
			_update_game_state(Input.MOUSE_MODE_VISIBLE, false, false, 1.0)
		GameState.PAUSE:
			_update_game_state(Input.MOUSE_MODE_VISIBLE, true, true, 0.0)


func _update_game_state(mouse_mode, show_menu, pause_tree, time_scale) -> void:
	Input.mouse_mode = mouse_mode
	player_ui_pause.visible = show_menu
	get_tree().paused = pause_tree
	Engine.time_scale = time_scale
	
	if player:
		player.immobile = (current_game_state != GameState.DEFAULT)
