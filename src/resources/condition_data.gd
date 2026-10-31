extends Resource
class_name ConditionData



@export var item: ItemData
@export var item_quantity: int
@export var item_given: ItemData
@export var completed: bool = false:
	set(value):
		# Сеттер сработает при изменении значения
		if completed == value: 
			return # Выходим, если значение не изменилось, чтобы не спамить сигналами		
		completed = value
		print("completed для ", self, "изменено на: ", completed)
		emit_changed() # Полезно для ресурсов, чтобы уведомить систему
		SignalBus.changed_condition_status.emit()
@export var dialogue_data: DialogueData

func _init() -> void:
	# Подключаем глобальный сигнал к функции внутри этого ресурса
#	SignalBus.is_picking.connect(_add_item)
	if not InventoryManager.update_inventory.is_connected(_add_item):
		InventoryManager.update_inventory.connect(_add_item)


func _add_item(_inventory_items) -> void:

	if InventoryManager.inventory_items.has(item.name):
		if InventoryManager.inventory_items[item.name].quantity >= item_quantity:
			self.completed = true
		else:
			self.completed = false

#			# Проверяем тип внутри ресурса предмета
#			if item.type == "Money":
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
		print('Не вернул')
		return false
	else:
		print('вернул')
		return true

