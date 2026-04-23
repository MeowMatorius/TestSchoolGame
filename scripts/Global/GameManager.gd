extends Node

## This determines wether the player can use the pause button, not wether the game will actually pause.
var game_paused : bool = false
enum game_state {Default, Mouse, Pause}
var current_game_state: int = 0

var player

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


func _process(_delta):
#	if current_game_state == game_state.Default:
#		pass
#	elif current_game_state == game_state.Mouse:
#		mouse_input_mode_switch()



	handle_pausing()


func handle_pausing():
	if Input.is_action_just_pressed("pause"):
		if current_game_state == game_state.Default:
			mouse_input_mode_switch()
		elif current_game_state == game_state.Mouse:
			mouse_input_mode_switch()


func mouse_input_mode_switch():
	if !game_paused:
		mouse_input_mode_on()
	else:
		mouse_input_mode_off()


func mouse_input_mode_on():
	game_paused = true
	
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	player.immobile = true
	player.jumping_enabled = false
	
	
func mouse_input_mode_off():
	game_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	player.immobile = false
	player.jumping_enabled = true
	
	
