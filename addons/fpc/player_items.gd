extends HBoxContainer

@export var ui_items: HBoxContainer
@export var ui_items_array: Array

var count_inventory = 0
func _ready() -> void:
	Inventory.is_adding_to_inventory.connect(add_to_inventory)
	ui_items_array = ui_items.get_children()


func add_to_inventory(items):
	count_inventory = 0		
	for i in items:
		ui_items_array[count_inventory].get_node("Label").text = str(items[i]["quantity"])
		ui_items_array[count_inventory].get_node("Icon").texture = items[i]["icon"]
		count_inventory +=1
		
