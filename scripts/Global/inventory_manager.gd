extends Node

@export var inventory_items: Dictionary[String, ItemData] = {}

signal update_inventory(inventory_items: Dictionary)


func _ready():
	SignalBus.is_picking.connect(add_item)


func add_item(item_data: ItemData):
	var item_data_name: String = item_data.name
	
	if inventory_items.has(item_data_name):
		if not inventory_items[item_data_name].unique:
			inventory_items[item_data_name].quantity += item_data.quantity
	else:
		inventory_items[item_data_name] = item_data.duplicate() # Дубль (Чтобы изменения не трогали исходный файл предмета)
	
	_refresh_inventory()


func remove_item(item_data_name: String) -> void:
	if not inventory_items.has(item_data_name): return
	
	var inventory_item: ItemData = inventory_items[item_data_name]
	if inventory_item.unique or inventory_item.quantity <= 1:
		inventory_items.erase(item_data_name)
	else:
		inventory_item.quantity -= 1
		
	_refresh_inventory()


# Выносим общую логику в отдельный метод
func _refresh_inventory():
	update_inventory.emit(inventory_items)
	print("Инвентарь обновлен: ", inventory_items.keys())
