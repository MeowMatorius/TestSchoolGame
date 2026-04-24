extends Interact

@export var one_time_use: bool = false
@export_enum("Activated", "Deactivated") var object_state: String = "Deactivated"
@export_enum("Включить", "Открыть", "Вытащить") var activate_prompt_message: String = "Открыть"
@export_enum("Выключить", "Закрыть", "Убрать") var deactivate_prompt_message: String = "Закрыть"
@export_enum("Unlocked", "Locked", "Broken") var lock_state: String = "Unlocked"
@export_enum("Key") var item_needed_to_open: String

signal is_switching
signal is_activated

var activated: bool = false
var is_opened: bool = false


func _ready() -> void:
	highlighted = false
	activated = false
	is_opened = false


func interact(object):
	if lock_state != "Locked":
		if !one_time_use:
			switch(object)
		if one_time_use:
			activate(object)
	else:
		unlock()



func unlock():
	if item_needed_to_open in InventoryManager.items:
		lock_state = "Unlocked"
		print("\n", get_script().resource_path.get_file(), ":\n", 'Разблокировано')
		InventoryManager.remove_item(item_needed_to_open)


func activate(object):
	is_activated.emit()
	object.get_node("AnimationPlayer").play("activate")
	object.set_collision_layer_value(2, false)
	print("\n", get_script().resource_path.get_file(), ":\n", "Игрок активировал ", name)


func switch(object):
	if object_state == "Deactivated":
		is_switching.emit()
		switch_on(object)
	else:
		is_switching.emit()
		switch_off(object)


func switch_on(object):
	object_state = "Activated"
	print("\n", get_script().resource_path.get_file(), ":\n", name, " Включен")
	
	if object.get_node("AnimationPlayer"):
		object.get_node("AnimationPlayer").play("activate")
	if object.get_node("AudioStreamPlayer3D"):
		object.get_node("AudioStreamPlayer3D").playing = true


func switch_off(object):
	object_state = "Deactivated"
	print("\n", get_script().resource_path.get_file(), ":\n", name, " Выключен")

	if object.get_node("AnimationPlayer"):
		object.get_node("AnimationPlayer").play("deactivate")
	if object.get_node("AudioStreamPlayer3D"):
		object.get_node("AudioStreamPlayer3D").playing = false


func get_prompt() -> String:
	if lock_state == "Locked":
		var has_item: bool = item_needed_to_open in InventoryManager.items
		return "Закрыто. Требуется: " + item_needed_to_open if not has_item else "Открыть с помощью: " + item_needed_to_open
	if lock_state == "Broken": return "Замок сломан"
	return activate_prompt_message if object_state == "Deactivated" else deactivate_prompt_message