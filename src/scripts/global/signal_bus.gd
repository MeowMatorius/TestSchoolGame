@warning_ignore("unused_signal")
extends Node

# Interact
signal is_picking(object_name: String) 		  # interact_pickup
signal is_item_needed(switch_data: SwitchData)# interact_switch
signal is_using_item(switch_data: SwitchData) # interact_switch (Посылает use_item_slot)
signal is_talking(internal_name: String) 	  # interact_talk
signal is_reading() 						  # interact_read
signal is_stoped_reading() 					  # interact_read

# Dialogue
signal entered_choice_menu(a)

# Event
signal event_triggered

# Quest
signal quest_completed(quest)
