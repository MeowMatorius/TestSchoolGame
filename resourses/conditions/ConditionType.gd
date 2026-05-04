extends Resource

class_name ConditionType

signal changed_status(condition: ConditionType)

@export var item: ItemData
@export var item_quantity: int
@export var item_given: ItemData
@export var completed: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		completed = value
		print("completed изменено на: ", completed)
		emit_changed() # Полезно для ресурсов, чтобы уведомить систему
		changed_status.emit(self)




func is_met() -> bool:
	var item_condition: Array[bool]
	print(InventoryManager.inventory_items)
	if InventoryManager.inventory_items.has(item.name):
		if InventoryManager.inventory_items[item.name].quantity < item_quantity:
			print(InventoryManager.inventory_items[item.name].quantity, ' < ', item_quantity)
			item_condition.append(false)
		else:
			item_condition.append(true)
	else:
		item_condition.append(false)
	if false in item_condition:
		return false
	else:
		completed = true
		return true