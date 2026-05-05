extends Interactable

@export var item_data: ItemData

signal object_removed


func interact(object):
	if InventoryManager.inventory_items.has(item_data.name):
		if item_data.unique and InventoryManager.inventory_items[item_data.name].quantity > 0: pass
		else: pick_up_item()
	else: pick_up_item()


func pick_up_item():
	SignalBus.is_picking.emit(item_data)
	get_parent().collision_layer = 0
	object_removed.emit()
	get_parent().queue_free()


func get_prompt() -> String:
	if !item_data.unique:
		return "Взять: " + item_data.name + " x" + str(item_data.quantity)
	else:
		if InventoryManager.inventory_items.has(item_data.name):
			if item_data.unique and InventoryManager.inventory_items[item_data.name].quantity > 0:
				return "Уже есть: " + item_data.name
			else: 
				return "Взять: " + item_data.name
		else:
			return "Взять: " + item_data.name
