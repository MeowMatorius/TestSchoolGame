extends Interactable

@onready var mesh = $MeshInstance3D
signal opened_door


func _ready() -> void:
	is_opened = false


func open_by_switch():
	is_opened = !is_opened
	print(name, " открыт: ", is_opened)
	if is_opened:
		opened_door.emit()
		var mat = mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = true
			mat.emission = Color(1.0, 0.0, 0.0, 1.0) # Зеленая подсветка
			mat.emission_energy_multiplier = 2.0
	else:
		var mat = mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat.emission_enabled = false
