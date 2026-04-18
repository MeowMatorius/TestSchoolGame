extends Interactable

@onready var mesh = $MeshInstance3D
var is_opened: bool = false

func open():
	if !is_opened:
		var mat = mesh.get_active_material(0)
			# print(mat)
		if mat is StandardMaterial3D:
			mat.emission_enabled = true
			mat.emission = Color(1.0, 0.0, 0.0, 1.0) # Зеленая подсветка
			mat.emission_energy_multiplier = 2.0
		is_opened = true
	else:
		var mat = mesh.get_active_material(0)
			# print(mat)
		if mat is StandardMaterial3D:
			mat.emission_enabled = false
		is_opened = false
