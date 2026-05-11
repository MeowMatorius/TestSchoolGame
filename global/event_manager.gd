extends Node

@export var global_events: Dictionary[String, EventData]

signal triggered_event(event_id)

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	print(global_events)
	if global_events.has('0001'):
		print('Отправили сигнал')
		global_events['0001'].triggered = true
		triggered_event.emit('0001')
	
	
func event_triggered(event_data, event_object):
	event_data.triggered = true
	event_object.visible = true
