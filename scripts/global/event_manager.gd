extends Node


func _ready() -> void:
	SignalBus.changed_condition_status.connect(start_event)

func start_event():
	print('Ивент ', 'запущен')
	pass
	
func start_first_quest():
	var command := CommandFactory.create_command(CommandFactory.CommandType.START_QUEST,ResourceLoader.load('uid://cs3x033chwxwl'))
	if command: command.execute(get_tree())
