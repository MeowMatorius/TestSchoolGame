extends CollisionObject3D
class_name Interactable

@export var prompt_message = "Interact"

signal is_picking
signal is_interacting

var interacting: bool = false
var highlighted: bool = false

@export_enum("Switch", "Pickup") var object_type: String

func _ready() -> void:
	highlighted = false
	interacting = false


func interact():
	if object_type == 'Switch':
		switch()
	if object_type == 'Pickup':
		pickup()


func switch():
	interacting = !interacting
	print(name, " активен: ", interacting)
	if interacting:
		is_interacting.emit()
	else:
		is_interacting.emit()


func pickup():
	is_picking.emit()
	print("Игрок поднял ", name)
	queue_free()


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
