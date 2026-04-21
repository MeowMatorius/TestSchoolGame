extends MeshInstance3D

@onready var material = get_active_material(0)



func _on_button_mouse_entered() -> void:
	print('навелись на куб')
	material.emission_enabled = true
	material.emission_energy_multiplier = 2.0
	material.emission = Color(0, 1, 0)


func _on_button_mouse_exited() -> void:
	material.emission_enabled = false
