extends Interact

enum ObjectState {ON, OFF}
@export var object_state: ObjectState = ObjectState.OFF
@export var one_time_use: bool = false
@export_enum("Включить", "Открыть", "Вытащить") var activate_prompt_message: String = "Открыть"
@export_enum("Выключить", "Закрыть", "Убрать") var deactivate_prompt_message: String = "Закрыть"

enum LockState {LOCKED, UNLOCKED, BROKEN}
@export var lock_state: LockState = LockState.UNLOCKED
@export_enum("Key") var item_needed_to_open: String

signal is_switching
signal is_activated


func interact(object):
	if lock_state == LockState.LOCKED:
		unlock()
	elif one_time_use:
		activate(object)
	else:
		switch(object)



func unlock():
	if item_needed_to_open in InventoryManager.items:
		lock_state = LockState.UNLOCKED
		InventoryManager.remove_item(item_needed_to_open)


func activate(object):
	is_activated.emit()
	object.get_node("AnimationPlayer").play("activate")
	object.set_collision_layer_value(2, false)


func switch(object):
	if object_state == ObjectState.OFF:
		is_switching.emit()
		switch_on(object)
	else:
		is_switching.emit()
		switch_off(object)


func switch_on(object):
	object_state = ObjectState.ON
	
	var anim = object.get_node_or_null("AnimationPlayer")
	if anim:
		anim.play("activate")
	
	var audio = object.get_node_or_null("AudioStreamPlayer3D")
	if audio:
		audio.play()


func switch_off(object):
	object_state = ObjectState.OFF
	print("\n", get_script().resource_path.get_file(), ":\n", name, " Выключен")

	var anim = object.get_node_or_null("AnimationPlayer")
	if anim:
		anim.play("deactivate")
	
	var audio = object.get_node_or_null("AudioStreamPlayer3D")
	if audio:
		audio.stop()


func get_prompt() -> String:
	
	if lock_state == LockState.LOCKED:
		var has_item: bool = item_needed_to_open in InventoryManager.items
		return "Требуется: " + item_needed_to_open if not has_item else "Открыть с помощью: " + item_needed_to_open
	
	if lock_state == LockState.BROKEN: return "Замок сломан"
	
	return activate_prompt_message if object_state == ObjectState.OFF else deactivate_prompt_message