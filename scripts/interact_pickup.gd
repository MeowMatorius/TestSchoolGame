extends Interact

@export var pickup_item_name: String = "Item"
@export_enum("Key", "Collectable", "Money") var pickup_item_type: String
@export var pickup_item_quantity: int = 1
@export var pickup_item_unique: bool = false
@export var pickup_item_icon: Texture2D

signal object_removed


func interact(object):
	SignalBus.is_picking.emit(pickup_item_name, pickup_item_icon, pickup_item_quantity, pickup_item_unique, pickup_item_type)
	print("\n", get_script().resource_path.get_file(), ":\n", "Игрок подобрал ", get_parent().name)
	
	get_parent().collision_layer = 0
	object_removed.emit()
	get_parent().queue_free()


func get_prompt() -> String:
	return "Подобрать"