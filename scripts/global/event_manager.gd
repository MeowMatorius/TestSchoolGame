extends Node

@export var global_events: Array[EventData]

signal triggered_event(event_id)

var index: int
var global: bool

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	print(global_events)
	index = get_inf_event('e_0001')[0]
	global = get_inf_event('e_0001')[1]
	if global:
		print('Отправили сигнал')
		global_events[index].triggered = true
		triggered_event.emit('e_0001')

func get_inf_event(event_id):
	return [global_events.find_custom(find_in_global(event_id)), global_events.any(find_in_global(event_id))]
	
func find_in_global(event_id):
	return func(event): return event.event_id == event_id

func event_triggered(event_data, event_object):
	event_data.triggered = true
	event_object.visible = true
