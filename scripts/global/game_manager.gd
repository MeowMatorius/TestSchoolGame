extends Node

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")

var is_game_paused: bool = false
var is_player_immobile: bool = false
var is_mouse_visible: bool = false

var is_in_dialogue: bool = false:
	set(value):
		if is_in_dialogue == value: return
		is_in_dialogue = value

var is_choosing_dialogue: bool = false:
	set(value):
		if is_choosing_dialogue == value: return
		is_choosing_dialogue = value

var is_choosing_item: bool = false:
	set(value):
		if is_choosing_item == value: return
		is_choosing_item = value

var is_reading: bool = false:
	set(value):
		if is_reading == value: return
		is_reading = value


func _ready() -> void:
	SignalBus.pause_pressed.connect(_on_pause_pressed)


func _on_pause_pressed() -> void:
	is_game_paused = !is_game_paused
	pause_tree(is_game_paused)
	mouse_visible(is_game_paused)
	SignalBus.game_paused.emit(is_game_paused)


func pause_tree(flag: bool = false):
	is_game_paused = flag
	get_tree().paused = flag
	

func mouse_visible(flag: bool = false):
	is_mouse_visible = flag
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if flag else Input.MOUSE_MODE_CAPTURED


func player_immobile(flag: bool = false):
	is_player_immobile = flag
	if player: player.immobile = flag