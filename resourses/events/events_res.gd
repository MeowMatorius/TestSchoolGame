class_name EventsRes
extends Resource


@export var triggered: bool = false
#@export_enum("Spawned", "Opened", "Trigered") var type: String
@export var name: String = "EventName"
@export var oneTimeTrigger: bool = true