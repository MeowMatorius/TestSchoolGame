extends Node
class_name Interact

@export_category("Двери/Контейнеры")

var prompt_message: String
var highlighted: bool = false


func _ready() -> void:
	highlighted = false


func interact(object): 
	pass


func highlight(object_mesh):
	if object_mesh is MeshInstance3D and !highlighted:
		highlighted = true
		var mat: Material = object_mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = true
			mat.emission = Color(1.0, 1.0, 1.0, 1.0) # Зеленая подсветка
			mat.emission_energy_multiplier = 0.05


func disable_highlight(object_mesh):
	if object_mesh is MeshInstance3D and highlighted:
		highlighted = false
		var mat: Material = object_mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = false
