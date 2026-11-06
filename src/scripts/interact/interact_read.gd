extends Interact

@export var prompt_text: String = 'Прочесть'
@export var noteScene: PackedScene
@export var close_read_menu_button: Button

var note_node: Node = null

func _ready():
	super._ready()
	object_type = ObjectType.READ


func _exit_tree() -> void:
	SignalUtilities.disconnect_signal(SignalBus.is_using_item, _close)


func interact(_target_object):
	if is_instance_valid(note_node): return
	if GameManager.current_game_state == GameManager.GameState.READING: return
	
	GameManager.current_game_state = GameManager.GameState.READING
	_instantiate_note()
	trigger_commands()


func get_prompt() -> String:
	return ' ' + prompt_text


func _instantiate_note() -> void:
	SignalBus.is_reading.emit()

	note_node = null
	note_node = noteScene.instantiate()
	add_child(note_node)
	
	close_read_menu_button = note_node.get_node('CloseButton')

	SignalUtilities.connect_signal(SignalBus.cancel_pressed, _close)
	SignalUtilities.connect_signal(close_read_menu_button.pressed, _close)


func _close():
	if GameManager.current_game_state != GameManager.GameState.READING: return
	
	GameManager.current_game_state = GameManager.GameState.DEFAULT
	SignalBus.is_stopped_reading.emit()

	SignalUtilities.disconnect_signal(SignalBus.cancel_pressed, _close)
	
	if is_instance_valid(note_node):
		note_node.queue_free()
		note_node = null
		
		if is_instance_valid(close_read_menu_button):
			close_read_menu_button = null
