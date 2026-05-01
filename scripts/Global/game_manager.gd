extends Node

# Смена состояния игры 
enum GameState {DEFAULT, DIALOGUE, PAUSE}
var current_game_state: GameState = GameState.DEFAULT:
	set(value):
		previous_game_state = current_game_state
		current_game_state = value
		_on_game_state_changed()

var previous_game_state: GameState
var state_before_pause: GameState

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var player_ui: Control = get_tree().get_first_node_in_group("player_ui")
@onready var player_ui_pause: Control = player_ui.get_node("PauseMenuContainer")
@onready var player_ui_dialogue: Control = player_ui.get_node("DialoguesContainer")
@onready var player_ui_default: Control = player_ui.get_node("DefaultContainer")

# Смена игровой камеры
@onready var player_camera: PhantomCamera3D = player.get_node("Head").get_node("CameraTarget").get_node("PhantomCamera3D")
var current_game_camera: PhantomCamera3D = player_camera:
	set(camera):
		previous_game_camera = current_game_camera
		current_game_camera = camera
		_on_switch_camera_smooth(current_game_camera, camera, 1)

var previous_game_camera: PhantomCamera3D


func _ready() -> void:
	current_game_state = GameState.DEFAULT
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
			_update_game_state(
				Input.MOUSE_MODE_CAPTURED, 
				false, 
				false, 
				1.0,
				false,
				false,
				true,
				)
		GameState.DIALOGUE:
			_update_game_state(
				Input.MOUSE_MODE_VISIBLE, 
				false, 
				false, 
				1.0,
				false,
				true,
				false,
				)
		GameState.PAUSE:
			_update_game_state(
				Input.MOUSE_MODE_VISIBLE, 
				true, 
				true, 
				0.0,
				true,
				false,
				false,
				)


func _update_game_state(
		mouse_mode, 
		show_menu, 
		pause_tree, 
		time_scale, 
		ui_pause_flg,
		ui_dialogue_flg,
		ui_default_flg
		) -> void:
	
	# Базовые флаги
	Input.mouse_mode = mouse_mode
	player_ui_pause.visible = show_menu
	get_tree().paused = pause_tree
	Engine.time_scale = time_scale
	
	# Переключение интерфейса
	player_ui_pause.visible = ui_pause_flg
	player_ui_dialogue.visible = ui_dialogue_flg
	player_ui_default.visible = ui_default_flg
	
	# Обездвижить игрока
	if player:
		player.immobile = (current_game_state != GameState.DEFAULT)


func _on_switch_camera_smooth(p_cam_1: PhantomCamera3D, p_cam_2: PhantomCamera3D, duration: float):
	if p_cam_1.priority > p_cam_2.priority:
		p_cam_1.priority = 0
		p_cam_2.priority = 10
	else:
		p_cam_1.priority = 10
		p_cam_2.priority = 0
