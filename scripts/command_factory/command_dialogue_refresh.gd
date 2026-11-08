class_name CommandDialogueRefresh
extends Command

var dialogue_resource: DialogueData

# Конструктор жестко требует объект квеста
func _init(p_dialogue_resource: DialogueData) -> void:
	dialogue_resource = p_dialogue_resource

func execute(_scene_tree: SceneTree) -> void:
	DialogueManager.refresh_active_quest_dialogues(dialogue_resource)