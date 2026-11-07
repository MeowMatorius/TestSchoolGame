extends Node

# Смена состояния игры 
enum GameState {DEFAULT, DIALOGUE, PAUSE, READING, USING_ITEM}
var current_game_state:
	set(value):
		if current_game_state == value: return
		current_game_state = value
		_on_game_state_changed()

var previous_game_state

# Ссылки на игрока и его UI
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var player_ui: Control = get_tree().get_first_node_in_group("player_ui")
@onready var player_ui_pause: Control = player_ui.get_node("%PauseMode")
@onready var player_ui_dialogue: Control = player_ui.get_node("%DialoguesMode")
@onready var player_ui_default: Control = player_ui.get_node("%DefaultMode")


func _ready() -> void:
	current_game_state = GameState.DEFAULT
	SignalBus.pause_pressed.connect(_on_pause_pressed)


func _on_pause_pressed() -> void:
	if current_game_state == GameState.PAUSE:
		current_game_state = previous_game_state
	elif previous_game_state != GameState.PAUSE:
		previous_game_state = current_game_state
		current_game_state = GameState.PAUSE


func _on_game_state_changed() -> void:
	match current_game_state:
		GameState.DEFAULT:
			_update_game_state(
				Input.MOUSE_MODE_CAPTURED, 
				false, 
				false,
				false,
				true,
				)
		GameState.USING_ITEM:
			_update_game_state(
					Input.MOUSE_MODE_VISIBLE,
					false,
					false,
					false,
					true,
					)
		GameState.DIALOGUE:
			_update_game_state(
				Input.MOUSE_MODE_VISIBLE, 
				false, 
				false,
				true,
				false,
				)
		GameState.READING:
			_update_game_state(
				Input.MOUSE_MODE_VISIBLE, 
				false, 
				false,
				false,
				true,
				)
		GameState.PAUSE:
			_update_game_state(
				Input.MOUSE_MODE_VISIBLE, 
				true, 
				true,
				false,
				false,
				)


func _update_game_state(
		mouse_mode,
		pause_tree,
		show_pause_menu_ui,
		show_dialogue_ui,
		show_default_ui
		) -> void:
	
	# Базовые флаги
	Input.mouse_mode = mouse_mode
	get_tree().paused = pause_tree
	
	# Переключение интерфейса
	player_ui_pause.visible = show_pause_menu_ui
	player_ui_dialogue.visible = show_dialogue_ui
	player_ui_default.visible = show_default_ui
	
	# Обездвижить игрока
	if player:
		player.immobile = (current_game_state != GameState.DEFAULT)
