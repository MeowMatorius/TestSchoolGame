extends VBoxContainer


@onready var quests_list: Array[Node] = self.get_children()

func _ready() -> void:
	print(quests_list)
	QuestManager.started_quest.connect(show_ui)
	QuestManager.stoped_quest.connect(_clear_ui)
	
func show_ui(quest):
	for i in range(quests_list.size()):
		if quests_list[i].has_meta("quest_id"):
			pass
		else:
			quests_list[i].visible = true	
			quests_list[i].text = quest.description
			quests_list[i].set_meta("quest_id", quest.id)
			break
	
func _clear_ui(quest):
	for i in range(quests_list.size()):
		if quests_list[i].has_meta("quest_id") and quests_list[i].get_meta("quest_id") == quest.id:
			quests_list[i].text = ""
			quests_list[i].visible = false	
			quests_list[i].remove_meta("quest_id")
			
#var quest_entry_scene = preload("res://ui/QuestEntry.tscn")
#
#func update_quest_list(quests):
#    # ... очистка ...
#    for quest in quests:
#        var entry = quest_entry_scene.instantiate()
#        entry.get_node("Title").text = quest.title
#        entry.set_meta("quest_id", quest.id)
#        container.add_child(entry)