extends Resource
class_name ConditionData

signal changed_status(condition: ConditionData)

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
@export var dialogue_data: DialogueData

#func _init() -> void:
#	# Подключаем глобальный сигнал к функции внутри этого ресурса
#	SignalBus.is_picking.connect(_add_item)
#

#func _add_item(item_data) -> void:
#
#	if item_data == item:
#		if InventoryManager.inventory_items.has(item.name):
#
#
#			# Проверяем тип внутри ресурса предмета
#			if item.type == ItemResource.ItemType.COIN:
#				# Изменение этой переменной автоматически триггерит сеттер 'set(value)' выше
#				coins += item.value 
#			else:
#				print("Ресурс проигнорирован. Это не монета, а: ", item.item_name)

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