extends CollisionObject3D
class_name Interactable

@export var prompt_message = "Interact"

signal is_picking
signal is_switching
signal is_activated

var switching: bool = false
var highlighted: bool = false
var activated: bool = false
var is_opened: bool = false



@export_enum("Switch", "Pickup", "Activate") var object_type: String

func _ready() -> void:
	highlighted = false
	switching = false
	activated = false
	is_opened = false

func interact(object_collision):
	if object_type == 'Switch':
		switch()
	if object_type == 'Pickup':
		pickup()
	if object_type == 'Activate':
		activate(object_collision)


func switch():
	switching = !switching
	print(name, " активен: ", switching)
	if switching:
		is_switching.emit()
		switch_on()
	else:
		is_switching.emit()
		switch_off()


func pickup():
	is_picking.emit()
	print("Игрок поднял ", name)
	queue_free()


func activate(object_collision):
	is_activated.emit()
	object_collision.set_collision_layer_value(2, false)
	print("Игрок активировал ", name)


func highlight(object_mesh, object_name):
	if object_mesh is MeshInstance3D and !highlighted:
		highlighted = true
		print(object_name, ' Подсветка: ', highlighted)
		
		var mat = object_mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = true
			mat.emission = Color(0, 1, 0) # Зеленая подсветка
			mat.emission_energy_multiplier = 2.0


func disable_highlight(object_mesh, object_name):
	if object_mesh is MeshInstance3D and highlighted:
		highlighted = false
		print(object_name, ' Подсветка: ', highlighted)
		
		var mat = object_mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = false
			
func switch_on():
	print(name, " Включен")

			
func switch_off():
	print(name, " ВЫключен")
