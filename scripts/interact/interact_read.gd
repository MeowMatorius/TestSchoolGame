extends Interact

@onready var ui_group: Array[Node] = get_tree().get_nodes_in_group('ui')
var read_container: Control

@export var prompt_text: String = 'Прочесть'
@export var noteScene: PackedScene
@export var enter_commands: Array[CommandData]
@export var exit_commands: Array[CommandData]

var close_read_menu_button: Button
var note_node: Node = null


func _ready():
	super._ready()
	object_type = ObjectType.READ
	read_container = ArrayUtilities.find_in_group(ui_group, 'ReadContainer')


func interact(_target_object):
	if is_instance_valid(note_node): return
	
	_instantiate_note()
	trigger_enter_commands(enter_commands)
	_set_game_manager_state(true)


func get_prompt() -> String:
	return ' ' + prompt_text


func _instantiate_note() -> void:
	note_node = null
	note_node = noteScene.instantiate()
	read_container.add_child(note_node)
	
	close_read_menu_button = note_node.get_node('CloseButton')

	SignalUtilities.connect_signal(SignalBus.cancel_pressed, _close)
	SignalUtilities.connect_signal(close_read_menu_button.pressed, _close, CONNECT_ONE_SHOT)


func _close():
	trigger_exit_commands(exit_commands)
	SignalUtilities.disconnect_signal(SignalBus.cancel_pressed, _close)
	_set_game_manager_state(false)
	
	if is_instance_valid(note_node):
		note_node.queue_free()
		note_node = null
		if is_instance_valid(close_read_menu_button):
			close_read_menu_button = null


func _set_game_manager_state(flag: bool = false):
	GameManager.is_reading = flag
	GameManager.player_immobile(flag)
	GameManager.mouse_visible(flag)
	UiManager.show_read_container(flag)
	GameManager.is_in_dialogue = flag
