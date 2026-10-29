extends Node

# Interact
signal is_picking(object_name)
signal is_talking(internal_name)
signal is_reading_note()
signal is_stoped_reading_note()

# Dialogue
signal entered_choice_menu(a)

# Event
signal event_triggered

# Quest
signal quest_completed(quest)
signal changed_quest_status(quest)

# SubQuest
signal changed_subquest_status(subquest)

# Condition
signal changed_condition_status()
