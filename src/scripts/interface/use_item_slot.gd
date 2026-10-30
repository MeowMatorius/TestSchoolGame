extends Control

@onready var icon_rect: TextureRect 		= $Button/MarginContainer/VBoxContainer/TextureRect
@onready var name_label: Label      		= $Button/MarginContainer/VBoxContainer/Label
@onready var button: Button         		= $Button
@onready var item_use_menu: GridContainer   = get_parent()

var slot_inventory_item: ItemData
var slot_switch_data: SwitchData


func display(inventory_item: ItemData, switch_data: SwitchData):
	slot_inventory_item = inventory_item
	slot_switch_data = switch_data

	icon_rect.texture = inventory_item.icon
	name_label.text = inventory_item.name


func _is_usable() -> bool:
	return slot_inventory_item != null \
			and slot_switch_data != null \
			and slot_inventory_item.name == slot_switch_data.item_needed_to_open.name


func clear():
	icon_rect.texture = null
	name_label.text = ""


func _on_button_button_up() -> void:
	if not _is_usable():
		GameManager.current_game_state = GameManager.GameState.DEFAULT
		item_use_menu.clear_slots()
	else:
		GameManager.current_game_state = GameManager.GameState.DEFAULT
		SignalBus.is_using_item.emit(slot_switch_data)
		InventoryManager.remove_item(slot_switch_data.item_needed_to_open, slot_switch_data.quantity_needed_to_open)
		item_use_menu.clear_slots()
