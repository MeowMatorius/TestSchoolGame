#TODO И ещё: _init() у Resource вызывается до того, как @export-поля заполнены значениями из файла. То есть в _init() item ещё может быть null. Это не влияет на подключение сигнала, но имейте в виду для любой логики в конструкторе.
extends Resource
class_name ConditionData

@export var item: ItemData
@export var item_quantity: int
@export var item_given: ItemData
var _completed: bool = false

@export var completed: bool:
	get: return _completed
	set(value):
		if _completed == value:
			return
		_completed = value
		emit_changed()
		SignalBus.changed_condition_status.emit()
@export var dialogue_data: DialogueData


func _init() -> void:
	# Подключаем глобальный сигнал к функции внутри этого ресурса
#	SignalBus.is_picking.connect(_add_item)
#	print('init')
	if not SignalBus.update_inventory.is_connected(_add_item):
		SignalBus.update_inventory.connect(_add_item)


func _add_item(_inventory_items) -> void:
#	print("_add_item вызван для ", self, " | resource_path: ", resource_path)
	if InventoryManager.inventory_items.has(item.name):
		if InventoryManager.inventory_items[item.name].quantity >= item_quantity:
			self.completed = true
		else:
			self.completed = false


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
