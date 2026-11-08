extends Node

@export var inventory_items: Dictionary[String, ItemData] = {}

func _ready():
	SignalBus.is_picking.connect(add_item)


func add_item(item_data: ItemData):
	var item_data_name: String = item_data.name
	
	if inventory_items.has(item_data_name):
		if not inventory_items[item_data_name].unique:
			inventory_items[item_data_name].quantity += item_data.quantity
	else:
		inventory_items[item_data_name] = item_data.duplicate() # Дубль (Чтобы изменения не трогали исходный файл предмета)
	SignalBus.added_to_inventory.emit(item_data)
	_refresh_inventory()


func remove_item(item_data: ItemData, quantity: int) -> void:
	if not inventory_items.has(item_data.name): return
	if item_data.reusable: return
	
	var inventory_item: ItemData = inventory_items[item_data.name]
	if inventory_item.unique or inventory_item.quantity - quantity <= 0:
		inventory_items.erase(item_data.name)
	else:
		inventory_item.quantity -= quantity
	SignalBus.removed_from_inventory.emit(item_data, quantity)
	_refresh_inventory()


func _refresh_inventory():
	SignalBus.update_inventory.emit(inventory_items)
	print("Инвентарь обновлен: ", inventory_items.keys())
