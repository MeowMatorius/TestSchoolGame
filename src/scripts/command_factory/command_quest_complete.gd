class_name CommandQuestComplete
extends Command

var quest_resource: QuestData


# Конструктор жестко требует объект квеста
func _init(p_quest_resource: QuestData) -> void:
	quest_resource = p_quest_resource


func execute(_scene_tree: SceneTree) -> void:
	QuestManager._complete_quest(quest_resource)
