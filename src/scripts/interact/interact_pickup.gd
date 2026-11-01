extends Interact

# Данные предмета
@export var item_data: ItemData


func _ready() -> void:
	super._ready()  # Только так работает _ready из основного Interact вместе с этим
	object_type = ObjectType.PICKUP # Тип объекта для иконки прицела


# Игрок нажал кнопку взаимодействия и смотрим на объект с помощью raycast
func interact(_target_object) -> void:
	if item_data == null:
		push_warning("InteractPickup: item_data не назначен у %s" % get_parent().name)
		return

	# Уникальный предмет повторно не подбираем
	if item_data.unique and _is_owned():
		return

	SignalBus.is_picking.emit(item_data)
	trigger_commands()

	var body := get_parent()

	# Метка для игнора объекта PlayerRaycast'ом перед удалением
	body.set_meta("is_being_removed", true)

	# Отключает слой коллизии даже если метка не сработала
	if body is CollisionObject3D:
		body.set_collision_layer_value(1, false)

	# Удаление объекта
	SignalBus.object_removed.emit()
	body.queue_free()


# Текст который PlayerRaycast показывает пока игрок смотрит на объект
func get_prompt() -> String:
	if item_data == null:
		return ""

	if item_data.unique:
		# Для уникального предмета не показываем количество
		return ("Уже есть: " if _is_owned() else " ") + item_data.name

	return "%s x%d" % [item_data.name, item_data.quantity]


# Проверка что предмет уже есть в инвентаре и его количество > 0
func _is_owned() -> bool:
	var item = InventoryManager.inventory_items.get(item_data.name)
	return item != null and item.quantity > 0