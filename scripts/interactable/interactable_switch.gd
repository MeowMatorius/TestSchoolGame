extends Interactable

@export var switch_data: SwitchData

signal is_switching
signal is_activated


func interact(object):
	if switch_data.lock_state == switch_data.LockState.LOCKED:
		unlock()
	elif switch_data.one_time_use:
		activate(object)
	else:
		switch(object)



func unlock():
	if switch_data.item_needed_to_open in InventoryManager.inventory_items:
		switch_data.lock_state = switch_data.LockState.UNLOCKED
		InventoryManager.remove_item(switch_data.item_needed_to_open)


func activate(object):
	is_activated.emit()
	object.get_node("AnimationPlayer").play("activate")
	object.set_collision_layer_value(2, false)


func switch(object):
	if switch_data.object_state == switch_data.ObjectState.OFF:
		is_switching.emit()
		switch_on(object)
	else:
		is_switching.emit()
		switch_off(object)


func switch_on(object):
	switch_data.object_state = switch_data.ObjectState.ON
	
	var anim = object.get_node_or_null("AnimationPlayer")
	if anim:
		anim.play("activate")
	
	var audio = object.get_node_or_null("AudioStreamPlayer3D")
	if audio:
		audio.play()


func switch_off(object):
	switch_data.object_state = switch_data.ObjectState.OFF

	var anim = object.get_node_or_null("AnimationPlayer")
	if anim:
		anim.play("deactivate")
	
	var audio = object.get_node_or_null("AudioStreamPlayer3D")
	if audio:
		audio.stop()


func get_prompt() -> String:
	
	if switch_data.lock_state == switch_data.LockState.LOCKED:
		var has_item: bool = switch_data.item_needed_to_open in InventoryManager.inventory_items
		return "Требуется: " + switch_data.item_needed_to_open if not has_item else "Открыть с помощью: " + switch_data.item_needed_to_open
	
	if switch_data.lock_state == switch_data.LockState.BROKEN: return "Замок сломан"
	
	return switch_data.activate_prompt_message if switch_data.object_state == switch_data.ObjectState.OFF else switch_data.deactivate_prompt_message
