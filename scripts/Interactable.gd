extends CollisionObject3D
class_name Interactable

@export_enum("Switch", "Pickup", "Activate") var object_type: String
@export_enum("Activated", "Deactivated") var object_state: String
@export var activate_prompt_message: String = "Включить"
@export var deactivate_prompt_message: String = "Выключить"

@export_category("Двери/Контейнеры")
@export_enum("Unlocked", "Locked", "Broken") var lock_state: String
@export_enum("Red Key", "Blue Key") var item_needed_to_open: String

@export_category("Подбираемое")
@export var pickup_item_name: String = "Item"
@export_enum("Key", "Collectable", "Money") var pickup_item_type: String
@export var pickup_item_quantity: int = 1
@export var pickup_item_uniq: bool = false
@export var pickup_item_icon: Texture2D

signal is_switching
signal is_activated

var prompt_message: String
var switching: bool = false
var highlighted: bool = false
var activated: bool = false
var is_opened: bool = false


func _ready() -> void:
	highlighted = false
	switching = false
	activated = false
	is_opened = false


func interact(object):
	if lock_state != "Locked":
		if object_type == 'Switch':
			switch(object)
		if object_type == 'Activate':
			activate(object)
	else:
		unlock()
	if object_type == 'Pickup':
		pickup()


func activate(object):
	is_activated.emit()
	object.get_node("AnimationPlayer").play("activate")
	object.set_collision_layer_value(2, false)
	print("\n", get_script().resource_path.get_file(), ":\n", "Игрок активировал ", name)


func switch(object):
	switching = !switching
	if switching:
		is_switching.emit()
		switch_on(object)
	else:
		is_switching.emit()
		switch_off(object)


func pickup():
	signal_bus.is_picking.emit(pickup_item_name, pickup_item_icon, pickup_item_quantity, pickup_item_uniq, pickup_item_type)
	print("\n", get_script().resource_path.get_file(), ":\n", "Игрок подобрал ", name)
	queue_free()


func highlight(object_mesh, object_name):
	if object_mesh is MeshInstance3D and !highlighted:
		highlighted = true
		# print("\n", get_script().resource_path.get_file(), ":\n", object_name, ' Подсветка: ', highlighted)
		
		var mat: Material = object_mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = true
			mat.emission = Color(1.0, 1.0, 1.0, 1.0) # Зеленая подсветка
			mat.emission_energy_multiplier = 0.05


func disable_highlight(object_mesh, object_name):
	if object_mesh is MeshInstance3D and highlighted:
		highlighted = false
		# print("\n", get_script().resource_path.get_file(), ":\n", object_name, ' Подсветка: ', highlighted)
		
		var mat: Material = object_mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = false


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


func unlock():
	if item_needed_to_open in Inventory.items:
		lock_state = "Unlocked"
		print("\n", get_script().resource_path.get_file(), ":\n", 'Разблокировано')
