extends Node
@warning_ignore_start("unused_signal")

# Dialogue
signal entered_choice_menu(a)
signal started_talking
signal start_choosing
signal start_quest

# Quest
signal quest_completed(quest)
signal changed_quest_status(quest)
signal started_quest
signal finished_quest

# SubQuest
signal changed_subquest_status(subquest)

# Condition
signal changed_condition_status()

# Event
signal triggered_event(event_id)


# Inventory
signal update_inventory(inventory_items: Dictionary)
signal added_to_inventory(item_data)
signal removed_from_inventory(item_data, quantity)


# InputManager
signal pause_requested
signal interaction_pressed
signal skip_pressed


# PlayerRaycast
signal is_targeting_object(target_object_interact) # Используется скриптом player_reticle для отображения иконки по типу объекта
signal is_not_targeting_object()


# interact_switch
signal is_switching
signal is_activated
signal is_item_needed(switch_data: SwitchData)
signal is_using_item(switch_data: SwitchData)

# interact_pickup
signal is_picking(object_name: String)
signal object_removed

# interact_talk
signal is_talking(internal_name: String)

# interact_read
signal is_reading()
signal is_stopped_reading()

@warning_ignore_restore("unused_signal")