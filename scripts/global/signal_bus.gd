extends Node
@warning_ignore_start("unused_signal")

# Dialogue
signal entered_choice_menu(flag: bool)
signal started_talking
signal start_choosing
signal start_quest
signal refresh_dialogue


# Quest
signal quest_completed(quest)
signal changed_quest_status(quest)
signal started_quest
signal finished_quest

# SubQuest
signal changed_subquest_status(subquest)

# Condition
signal changed_condition_status()


# Inventory
signal update_inventory(inventory_items: Dictionary)
signal added_to_inventory(item_data)
signal removed_from_inventory(item_data, quantity)


# GameManager
signal game_paused(flag: bool)


# InputManager
signal pause_pressed
signal interaction_pressed
signal skip_pressed
signal cancel_pressed

# PlayerRaycast
signal is_targeting_object(target_object_interact)
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

@warning_ignore_restore("unused_signal")
