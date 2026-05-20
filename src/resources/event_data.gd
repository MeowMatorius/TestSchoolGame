class_name EventData
extends Resource

@export var event_id: String = "0001"
@export var event_name: String = "EventName"
@export var triggered: bool = false

@export var event_start: bool = false
@export var event_over: bool = false
@export var next_event_data: EventData

@export var quest_data: QuestData
@export var npc: Array[NpcData]
