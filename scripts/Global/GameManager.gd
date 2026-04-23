extends Node

enum game_state {Default, Mouse, Pause}
var game_paused : bool = false

var current_game_state: int = 0
var previous_game_state
var state_before_pause

var player
var pause_menu_ui

func find_all_descendants():
	for child in get_parent().get_children():
		for i in child.get_children():
			if i.has_node("Player") == false:
				pass
			else:
				player = i.get_node("Player")


func _ready() -> void: 
	find_all_descendants()
	current_game_state = game_state.Default
	pause_menu_ui = player.get_node("UserInterface").get_node('PauseMenu')
	

func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("pause"):
		previous_game_state = current_game_state
		current_game_state = game_state.Pause
		mouse_input_mode_switch()


func mouse_input_mode_switch():
	if current_game_state == game_state.Default:
		mouse_input_mode_off()
		print("Нахожусь в состоянии Default")
	elif current_game_state == game_state.Mouse:
		mouse_input_mode_on()
		print("Нахожусь в состоянии Mouse")
	elif current_game_state == game_state.Pause:
		if previous_game_state != current_game_state:
			mouse_input_mode_on(true, 0.0)
			state_before_pause = previous_game_state
			print("Нахожусь в состоянии Pause")
		else:
			mouse_input_mode_off()
			current_game_state = state_before_pause
#			print("Нахожусь в состоянии ", current_game_state)
			mouse_input_mode_switch()
			

func mouse_input_mode_on(visible: bool = false, pause_time: float = 1.0):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause_menu_ui.visible = visible
	Engine.time_scale = pause_time
	player.immobile = true
	
	
func mouse_input_mode_off(visible: bool = false):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu_ui.visible = visible
	Engine.time_scale = 1
	player.immobile = false
	
	
