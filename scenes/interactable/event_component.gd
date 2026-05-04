extends Node3D


@export var event_data: EventsRes
@export var event_object: Node3D

func _ready() -> void:
	get_parent().get_node("InteractComponent").is_switching.connect(switching)
	
func switching():
	print('Переключили радио')
	SignalBus.event_triggered.emit(event_data, event_object)