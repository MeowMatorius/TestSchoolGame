extends Interact

@export var prompt_text: String = 'Прочесть'
@export var noteScene: PackedScene
@export var enter_commands: Array[CommandData]
@export var exit_commands: Array[CommandData]

var close_read_menu_button: Button
var note_node: Node = null


func _ready():
	super._ready()
	object_type = ObjectType.READ


func interact(_target_object):
	if is_instance_valid(note_node): return
	if GameManager.current_game_state == GameManager.GameState.READING: return
	
	GameManager.current_game_state = GameManager.GameState.READING
	_instantiate_note()
	trigger_enter_commands(enter_commands)


func get_prompt() -> String:
	return ' ' + prompt_text


func _instantiate_note() -> void:
	note_node = null
	note_node = noteScene.instantiate()
	add_child(note_node)
	
	close_read_menu_button = note_node.get_node('CloseButton')

	SignalUtilities.connect_signal(SignalBus.cancel_pressed, _close)
	SignalUtilities.connect_signal(close_read_menu_button.pressed, _close, CONNECT_ONE_SHOT)


func _close():
	if GameManager.current_game_state != GameManager.GameState.READING: return
	
	GameManager.current_game_state = GameManager.GameState.DEFAULT
	trigger_exit_commands(exit_commands)
	SignalUtilities.disconnect_signal(SignalBus.cancel_pressed, _close)
	
	if is_instance_valid(note_node):
		note_node.queue_free()
		note_node = null
		if is_instance_valid(close_read_menu_button):
			close_read_menu_button = null
