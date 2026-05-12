extends Node

# Interact
signal is_picking(object_name)
signal is_talking(internal_name)
signal is_reading(note_data)

# Dialogue
signal entered_choice_menu(a)

# Event
signal event_triggered

# Quest
signal quest_completed(quest)
