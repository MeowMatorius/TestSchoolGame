extends Node

@warning_ignore_start("unused_signal")

# PlayerRaycast
signal is_targeting_object(target_object_interact) # Используется скриптом player_reticle для отображения иконки по типу объекта
signal is_not_targeting_object()

# Interact
signal is_picking(object_name: String) 		  # interact_pickup
signal is_item_needed(switch_data: SwitchData)# interact_switch
signal is_using_item(switch_data: SwitchData) # interact_switch (Посылает use_item_slot)
signal is_talking(internal_name: String) 	  # interact_talk
signal is_reading() 						  # interact_read
signal is_stopped_reading() 				  # interact_read

# Dialogue
signal entered_choice_menu(a)
signal started_talking
signal start_choosing
signal start_quest

# Event
signal triggered_event(event_id)

# Quest
signal quest_completed(quest)
signal changed_quest_status(quest)
signal started_quest
signal finished_quest

# SubQuest
signal changed_subquest_status(subquest)

# Condition
signal changed_condition_status()

@warning_ignore_restore("unused_signal")