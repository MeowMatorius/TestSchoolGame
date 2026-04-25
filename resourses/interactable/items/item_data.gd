class_name ItemData
extends Resource

@export var unique: bool = false
@export_enum("Key", "Collectable", "Money") var type: String
@export var name: String
@export var quantity: int = 1
@export var icon: Texture2D