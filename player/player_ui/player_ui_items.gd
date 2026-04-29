extends Control

var ui_item_slots: Array[Node] = []


func _ready() -> void:
	InventoryManager.update_inventory.connect(_on_inventory_updated)
	ui_item_slots = self.get_children()
	clear_inventory()


func _on_inventory_updated(inventory_items: Dictionary):
	clear_inventory()
	
	var inventory_items_list: Array = inventory_items.values()
	
	for i in range(min(inventory_items_list.size(), ui_item_slots.size())):
		ui_item_slots[i].display(inventory_items_list[i])


func clear_inventory():
	for ui_item_slot in ui_item_slots:
		ui_item_slot.clear()
