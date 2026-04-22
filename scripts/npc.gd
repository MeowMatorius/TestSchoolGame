extends Node3D

class_name NPC

@export var internal_name: String = "NPC"
@export var dialogue_stage: String = "dialogue_1"

var highlighted: bool = false
var prompt_message: String



func _ready() -> void:
	highlighted = false
	pass


func talk():
	signal_bus.is_talking.emit(internal_name, dialogue_stage)


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
