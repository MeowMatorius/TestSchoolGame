extends Panel

@onready var icon_rect: TextureRect = $Icon 
@onready var name_label: Label = $Name
@onready var quantity_label: Label = $Quantity


func display(inventory_item: ItemData):
	icon_rect.texture = inventory_item.icon
	name_label.text = inventory_item.name
	
	if not inventory_item.unique and inventory_item.quantity > 1:
		quantity_label.text = str(inventory_item.quantity)
	else:
		quantity_label.text = ""


func clear():
	icon_rect.texture = null
	name_label.text = ""
	quantity_label.text = ""
