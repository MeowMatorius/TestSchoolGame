extends Control

@export var ui_items: HBoxContainer

var ui_items_array: Array

var count_inventory: int = 0
func _ready() -> void:
	InventoryManager.update_inventory.connect(add_to_inventory)
	ui_items_array = ui_items.get_children()


func add_to_inventory(items):
	count_inventory = 0
	clear_inventory()
	for i in items:
		if items[i]["unique"] == false:
			ui_items_array[count_inventory].get_node("Label").text = str(items[i]["quantity"])
		else:
			ui_items_array[count_inventory].get_node("Label").text = ''
		ui_items_array[count_inventory].get_node("Icon").texture = items[i]["icon"]
		count_inventory +=1
	print("\n", get_script().resource_path.get_file(), ":\n", "UI Предметов обновлен")

func clear_inventory():
	for i in ui_items_array:
		i.get_node("Label").text = ''
		i.get_node("Icon").texture = null
