extends Node

var unloked_area: bool = false

func _ready() -> void:
	SignalBus.event_triggered.connect(event_triggered)
	
func event_triggered(event_data, event_object):
	unloked_area = true
	event_data.triggered = true
	event_object.visible = true

