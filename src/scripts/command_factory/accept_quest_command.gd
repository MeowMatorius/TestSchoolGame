# AcceptQuestCommand.gd
class_name AcceptQuestCommand
extends DialogCommand

var quest_resource: QuestData

# Конструктор жестко требует объект квеста
func _init(p_quest_resource: QuestData) -> void:
	quest_resource = p_quest_resource

func execute(scene_tree: SceneTree) -> void:
	QuestManager.track_quest(quest_resource)
