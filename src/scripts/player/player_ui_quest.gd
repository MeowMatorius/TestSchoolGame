extends VBoxContainer

var quest_entry_scene: PackedScene = preload("uid://c5ktdafkof5xx")
var icon_done = preload("uid://cbihmmy1lpu4t")
var quest_list: Array[Node]

var sub_quest_scene: PackedScene = preload("uid://b4paruxiqtp6x")
#@onready var sub_quest_list: VBoxContainer = $VBoxContainer/MarginContainer/SubQuestList

func _ready() -> void:
	quest_list = []
	QuestManager.started_quest.connect(show_ui)
	QuestManager.stoped_quest.connect(_clear_ui)
	SignalBus.quest_completed.connect(mark_done)

	
func show_ui(quest):
	var entry = quest_entry_scene.instantiate()
	entry.get_node("Quest").get_node("Label").text = quest.description
	entry.set_meta("quest_id", quest.id)
	entry.set_meta("is_quest", true)
	self.add_child(entry)
	quest_list.append(entry)
	if quest.subquest != null:
		for sub_quest in quest.subquest:
			var sub_node = sub_quest_scene.instantiate()
			entry.get_node("SubQuestContainer").add_child(sub_node)
			sub_node.set_meta("quest_id", sub_quest.id)
			sub_node.set_meta("is_quest", false)
			quest_list.append(sub_node)
			# Инициализируем текст и галочку выполнения
			sub_node.get_node("Label").text = sub_quest.description
			
	
func _clear_ui(quest):
	pass
#	for i in range(quests_list.size()):
#		if quests_list[i].has_meta("quest_id") and quests_list[i].get_meta("quest_id") == quest.id:
#			quests_list[i].text = ""
#			quests_list[i].visible = false	
#			quests_list[i].remove_meta("quest_id")
		
			
func mark_done(quest):
	print('Залетели чтоб поставить галочку для ', quest.id)
	for i in quest_list:
		if i.has_meta("quest_id") and i.get_meta("quest_id") == quest.id:
			if i.get_meta("is_quest") == true:
				i.get_node("Quest").get_node("TextureRect").texture = icon_done
			else:
				i.get_node("TextureRect").texture = icon_done
#			i.get_node("TextureRect").texture = icon_done
		
#var quest_entry_scene = preload("res://ui/QuestEntry.tscn")


#func update_quest_list(quests):
#    # ... очистка ...
#    for quest in quests:
#        var entry = quest_entry_scene.instantiate()
#        entry.get_node("Title").text = quest.title
#        entry.set_meta("quest_id", quest.id)
#        container.add_child(entry)
