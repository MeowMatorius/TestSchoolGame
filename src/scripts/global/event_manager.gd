extends Node


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	start_first_quest()


func start_first_quest():
	var command := CommandFactory.create_command(CommandFactory.CommandType.START_QUEST,ResourceLoader.load('uid://cs3x033chwxwl'))
	if command: command.execute(get_tree())
