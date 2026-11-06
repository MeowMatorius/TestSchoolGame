extends Control

@export var close_item_menu_button: Button
@export var item_scene: PackedScene = preload('uid://cwwxusyuudl6k')

var inventory_items: Dictionary[String, ItemData] = InventoryManager.inventory_items
var use_item_slots: Array[Node] = []


func _ready() -> void:
	SignalUtilities.connect_all(_signal_pairs())


func _exit_tree() -> void:
	SignalUtilities.disconnect_all(_signal_pairs())


func _signal_pairs() -> Array:
	return [
		[SignalBus.is_item_needed, _instantiate_items],
		[SignalBus.is_using_item, _close],
		[close_item_menu_button.pressed, _close],
		[SignalBus.cancel_pressed, _close],
	]


func _instantiate_items(switch_data: SwitchData) -> void:
	GameManager.current_game_state = GameManager.GameState.USING_ITEM

	_clear_slots()

	# Фильтр на подходящие предметы
	var matching_items: Array[ItemData] = []
	for item: ItemData in inventory_items.values():
		if item.type == switch_data.item_needed_to_open.type:
			matching_items.append(item)

	if matching_items.is_empty():
		visible = false
		GameManager.current_game_state = GameManager.GameState.DEFAULT
		return

	visible = true
	fill_slots(switch_data, matching_items)


func fill_slots(switch_data: SwitchData, matching_items: Array[ItemData]) -> void:
	close_item_menu_button.visible = true
	
	for item: ItemData in matching_items:
		var slot: Node = item_scene.instantiate()
		add_child(slot)
		use_item_slots.append(slot)
		slot.display(item, switch_data)


func _close(_data = null) -> void:
	if not visible: return
	
	visible = false
	_clear_slots()
	
	if GameManager.current_game_state == GameManager.GameState.USING_ITEM:
		GameManager.current_game_state = GameManager.GameState.DEFAULT


func _clear_slots() -> void:
	close_item_menu_button.visible = false

	for slot: Node in use_item_slots:
		if is_instance_valid(slot):
			slot.queue_free()
	use_item_slots.clear()
