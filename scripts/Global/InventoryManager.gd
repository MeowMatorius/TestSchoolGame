extends Node

signal update_inventory
@export var items = {}


func _ready():
	SignalBus.is_picking.connect(add_item) 


func add_item(pickup_item_name, pickup_item_icon, pickup_item_quantity, pickup_item_unique, pickup_item_type):
	if items.has(pickup_item_name) and pickup_item_unique:
		pass
	elif items.has(pickup_item_name) and !pickup_item_unique:
		items[pickup_item_name]["quantity"] += pickup_item_quantity
	else:
		items[pickup_item_name] = {
			"name": pickup_item_name, 
			"type": pickup_item_type, 
			"quantity": pickup_item_quantity, 
			"unique": pickup_item_unique,
			"icon": pickup_item_icon
			}
	update_inventory.emit(items)
	print("\n", get_script().resource_path.get_file(), ":\n", "Инвентарь обновлен: \n", items)
	
func remove_item(pickup_item_name):
	if items[pickup_item_name]["unique"] == true:
		items.erase(pickup_item_name)
	elif items[pickup_item_name]["unique"] == false and items[pickup_item_name]["quantity"] > 1:
		items[pickup_item_name]["quantity"] -= 1
	update_inventory.emit(items)
	print("\n", get_script().resource_path.get_file(), ":\n", "Инвентарь обновлен: \n", items)
