class_name CommandItemExchange
extends Command

var item_reward_resource: ItemData # Что получаем
var item_required_resource: ItemData # Что отдаем
var item_required_quantity: int # Сколько отдаем

# Конструктор жестко требует объект квеста
func _init(p_item_reward_resource: ItemData, p_item_required_resource: ItemData, p_item_required_quantity) -> void:
	item_reward_resource = p_item_reward_resource
	item_required_resource = p_item_required_resource
	item_required_quantity = p_item_required_quantity

func execute(_scene_tree: SceneTree) -> void:
	InventoryManager.remove_item(item_required_resource, item_required_quantity)
	InventoryManager.add_item(item_reward_resource)