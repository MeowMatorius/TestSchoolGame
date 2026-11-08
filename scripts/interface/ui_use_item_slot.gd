extends Control

@onready var icon_rect: TextureRect = $Button/MarginContainer/VBoxContainer/TextureRect
@onready var name_label: Label      = $Button/MarginContainer/VBoxContainer/Label
@onready var button: Button         = $Button

var slot_inventory_item: ItemData
var slot_switch_data: SwitchData


func _ready() -> void:
	button.pressed.connect(_on_pressed)


func display(inventory_item: ItemData, switch_data: SwitchData) -> void:
	slot_inventory_item = inventory_item
	slot_switch_data = switch_data

	icon_rect.texture = inventory_item.icon
	name_label.text = inventory_item.name


func _is_usable() -> bool:
	return slot_inventory_item != null \
			and slot_switch_data != null \
			and slot_inventory_item.name == slot_switch_data.item_needed_to_open.name


func clear() -> void:
	icon_rect.texture = null
	name_label.text = ""


func _on_pressed() -> void:
	if _is_usable():
		InventoryManager.remove_item(
				slot_switch_data.item_needed_to_open,
				slot_switch_data.quantity_needed_to_open
		)
		SignalBus.is_using_item.emit(slot_switch_data)
