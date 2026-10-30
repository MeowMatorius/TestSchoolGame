extends Control

@export var close_item_menu_button: Button
var item_scene: PackedScene = preload('uid://cwwxusyuudl6k')
var item_icon: Texture2D = preload('uid://d1qxknlfg57ty')
var item_name: String = 'item_name'

var inventory_items: Dictionary[String, ItemData] = InventoryManager.inventory_items
var use_item_slots: Array[Node] = []


func _ready() -> void:
	SignalBus.is_item_needed.connect(instantiate_items)
	SignalBus.is_using_item.connect(clear_slots)


func instantiate_items(switch_data: SwitchData) -> void:
	GameManager.current_game_state = GameManager.GameState.USING_ITEM

	for child in get_children():
		if child in use_item_slots or child.has_method("display"):
			child.queue_free()
	clear_slots()
	
	# Фильтр на подходящие предметы
	var matching_items: Array[ItemData] = []
	for item: ItemData in inventory_items.values():
		if item.type == switch_data.item_needed_to_open.type:
			matching_items.append(item)

	if matching_items.is_empty():
		GameManager.current_game_state = GameManager.GameState.DEFAULT

	fill_slots(switch_data, matching_items)


# Создание слотов
func fill_slots(switch_data: SwitchData, matching_items: Array[ItemData]) -> void:
	if close_item_menu_button.visible: return
	else: close_item_menu_button.visible = true
	
	for item: ItemData in matching_items:
		var slot: Node = item_scene.instantiate()
		add_child(slot)
		use_item_slots.append(slot)
		slot.display(item, switch_data)


# Чистка слотов
func clear_slots(_data = null) -> void:
	if !close_item_menu_button.visible: return
	else: close_item_menu_button.hide_button()
	
	for slot: Node in use_item_slots:
		if is_instance_valid(slot):
			slot.queue_free()
	use_item_slots.clear()
