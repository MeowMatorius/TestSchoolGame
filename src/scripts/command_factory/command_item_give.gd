class_name CommandItemGive
extends Command

var item_resource: ItemData


# Конструктор жестко требует объект квеста
func _init(p_item_resource: ItemData) -> void:
	item_resource = p_item_resource


func execute(_scene_tree: SceneTree) -> void:
	InventoryManager.add_item(item_resource)