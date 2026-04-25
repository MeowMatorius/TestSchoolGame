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
@onready var player_ui: CanvasLayer = player.get_node("UserInterface")
@onready var player_ui_pause: Control = player_ui.get_node("PauseMenuContainer")
@onready var player_ui_prompt: Control = player_ui.get_node("InteractPrompt")
@onready var player_ui_dialogue: Control = player_ui.get_node("DialoguesContainer")
@onready var player_ui_inventory: Control = player_ui.get_node("ItemsContainer")

# Смена игровой камеры
@onready var player_camera: Camera3D = player.get_node("Head").get_node("Camera")
var current_game_camera: Camera3D = player_camera:
	set(camera):
		previous_game_camera = current_game_camera
		current_game_camera = camera
		_on_switch_camera_smooth(current_game_camera, camera, 1)

var previous_game_camera: Camera3D


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
				false,
				true
				)
		GameState.DIALOGUE:
			_update_game_state(
				Input.MOUSE_MODE_VISIBLE, 
				false, 
				false, 
				1.0,
				false,
				false,
				true,
				true
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
				false
				)


func _update_game_state(
		mouse_mode, 
		show_menu, 
		pause_tree, 
		time_scale, 
		ui_pause_flg,
		ui_prompt_flg,
		ui_dialogue_flg,
		ui_inventory_flg
		) -> void:
	
	# Базовые флаги
	Input.mouse_mode = mouse_mode
	player_ui_pause.visible = show_menu
	get_tree().paused = pause_tree
	Engine.time_scale = time_scale
	
	# Переключение интерфейса
	player_ui_pause.visible = ui_pause_flg
	player_ui_prompt.visible = ui_prompt_flg
	player_ui_dialogue.visible = ui_dialogue_flg
	player_ui_inventory.visible = ui_inventory_flg
	
	# Обездвижить игрока
	if player:
		player.immobile = (current_game_state != GameState.DEFAULT)


func _on_switch_camera_smooth(from_cam: Camera3D, to_cam: Camera3D, duration: float):
	# Копируем параметры целевой камеры, чтобы начать движение к ним
	var tween: Tween = create_tween().set_parallel(true)

	# Плавно меняем позицию и поворот
	tween.tween_property(from_cam, "global_transform", to_cam.global_transform, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	# Если нужно плавно сменить угол обзора (FOV)
	tween.tween_property(from_cam, "fov", to_cam.fov, duration)

	await tween.finished
	to_cam.make_current()
