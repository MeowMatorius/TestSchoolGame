class_name Interact
extends Node

var highlighted: bool = false


func _ready() -> void:
	highlighted = false


func set_shader_effect(mesh: MeshInstance3D, enabled: bool) -> void:
	var next: Material = null
	
	if mesh and mesh.material_override and mesh.material_override.next_pass:
		next = mesh.material_override.next_pass
	else: return

	if next is ShaderMaterial:
		next.set_shader_parameter("effect_strength", 1.0 if enabled else 0.0)
