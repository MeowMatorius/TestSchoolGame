extends Interactable

@export var item_data: ItemData

signal object_removed


func interact(object):
	SignalBus.is_picking.emit(item_data)
	
	get_parent().collision_layer = 0
	object_removed.emit()
	get_parent().queue_free()


func get_prompt() -> String:
	return "Взять: " + item_data.name
