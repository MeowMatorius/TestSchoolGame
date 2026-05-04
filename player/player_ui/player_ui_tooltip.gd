extends VBoxContainer

@onready var slots = get_children()
var item_queue: Array = []


func _ready() -> void:
	if not InventoryManager.added_to_inventory.is_connected(_on_item_added):
		InventoryManager.added_to_inventory.connect(_on_item_added)
	
	if not InventoryManager.removed_from_inventory.is_connected(_on_item_removed):
		InventoryManager.removed_from_inventory.connect(_on_item_removed)
	
	for slot in slots:
		slot.visible = false
		slot.modulate.a = 0.0
		slot.custom_minimum_size.y = 0
		slot.set_meta("is_animating", false)


func _on_item_added(item_data):
	_process_notification(item_data.name, item_data.quantity, item_data.icon, "added")


func _on_item_removed(item_data, quantity):
	_process_notification(item_data.name, quantity, item_data.icon, "removed")


func _process_notification(item_name: String, item_quantity: int, item_icon: Texture2D, type: String):
	item_queue.push_back({
		"name": item_name, 
		"quantity": item_quantity, 
		"icon": item_icon, 
		"type": type
	})
	_check_queue()


func _check_queue() -> void:
	if item_queue.is_empty():
		return
	var free_slot = _get_free_slot()
	if free_slot:
		var next_entry = item_queue.pop_front()
		_animate_slot(free_slot, next_entry.name, next_entry.quantity, next_entry.icon, next_entry.type)


func _get_free_slot() -> Node:
	for slot in slots:
		if not slot.visible and not slot.get_meta("is_animating", false):
			return slot
	return null


func _animate_slot(slot: Control, item_name: String, item_quantity: int, item_icon: Texture2D, type: String) -> void:
	slot.set_meta("is_animating", true)
	
	slot.get_node("Icon").texture = item_icon
	var text_node = slot.get_node("ToolpitText")
	
	if type == "added":
		text_node.text = "+ %d %s" % [item_quantity, item_name]
		text_node.modulate = Color.GREEN
	else:
		text_node.text = "- %d %s" % [item_quantity, item_name]
		text_node.modulate = Color.TOMATO
	
	slot.custom_minimum_size.y = 0
	slot.modulate.a = 0.0
	slot.visible = true
	move_child(slot, 0)
	
	var tween: Tween = create_tween()
	tween.tween_property(slot, "custom_minimum_size:y", 30, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(slot, "modulate:a", 1.0, 0.3)
	
	tween.tween_interval(4.0)
	
	tween.chain().tween_property(slot, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(slot, "custom_minimum_size:y", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(func():
		slot.visible = false
		slot.set_meta("is_animating", false)
		_check_queue()
	)
