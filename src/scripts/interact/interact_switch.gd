extends Interact

@export var switch_data: SwitchData
@export var event_data: EventData
@export var quest_data: QuestData


func _ready() -> void:
	object_type = ObjectType.SWITCH
	
	SignalBus.is_using_item.connect(unlock)
	
	match switch_data.object_state:
		SwitchData.ObjectState.OFF:
			switch_off(get_parent())
		SwitchData.ObjectState.ON:
			switch_on(get_parent())


func interact(object):
	if switch_data.lock_state == switch_data.LockState.LOCKED:
		GameManager.current_game_state = GameManager.GameState.USING_ITEM
		SignalBus.is_item_needed.emit(switch_data)
	elif switch_data.one_time_use:
		activate(object)
	else:
		switch(object)

	trigger_command()


func unlock(used_switch_data: SwitchData):
	if used_switch_data != switch_data: return
	used_switch_data.lock_state = switch_data.LockState.UNLOCKED


func activate(object):
	if switch_data.lock_state == switch_data.LockState.BROKEN:
		return;
	SignalBus.is_activated.emit()
	object.get_node("AnimationPlayer").play("activate")
	object.set_collision_layer_value(2, false) # Если объект можно будет ресетнуть то придется думать над альтернативой


func switch(object) -> void:
	if switch_data.lock_state == switch_data.LockState.BROKEN:
		return;
	if switch_data.object_state == switch_data.ObjectState.OFF:
		SignalBus.is_switching.emit()
		switch_on(object)
	else:
		SignalBus.is_switching.emit()
		switch_off(object)


func switch_on(object):
	if switch_data.object_state == SwitchData.ObjectState.ON: return
	
	switch_data.object_state = switch_data.ObjectState.ON
	
	var anim = object.get_node_or_null("AnimationPlayer")
	if anim:
		anim.play("activate")
	
	var audio = object.get_node_or_null("AudioStreamPlayer3D")
	if audio:
		audio.play()


func switch_off(object):
	if switch_data.object_state == SwitchData.ObjectState.OFF: return
	
	switch_data.object_state = switch_data.ObjectState.OFF

	var anim = object.get_node_or_null("AnimationPlayer")
	if anim:
		anim.play("deactivate")
	
	var audio = object.get_node_or_null("AudioStreamPlayer3D")
	if audio:
		audio.stop()


func get_prompt() -> String:
	if switch_data.lock_state == switch_data.LockState.LOCKED:
		#var has_item: bool = switch_data.item_needed_to_open.name in InventoryManager.inventory_items
		#return "Требуется: " + switch_data.item_needed_to_open.name if not has_item else "Открыть с помощью: " + switch_data.item_needed_to_open.name
		return "Закрыто"
	
	if switch_data.lock_state == switch_data.LockState.BROKEN: return "Замок сломан"
	
	return switch_data.activate_prompt_message if switch_data.object_state == switch_data.ObjectState.OFF else switch_data.deactivate_prompt_message
