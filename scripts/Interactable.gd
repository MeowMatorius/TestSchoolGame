extends CollisionObject3D
class_name Interactable

@export var prompt_message = "Interact"
signal is_interacting
signal is_picking
var is_highlighted: bool = false

func _ready() -> void:
	is_highlighted = false

func interact(body):
	is_interacting.emit()
	print(body.name, " interacted with ", name)
	return true
	
func pickup(body):
	is_picking.emit()
	print(body.name, " поднял ", name)
	
func highlight(mesh):
	if mesh is MeshInstance3D and !is_highlighted:
		is_highlighted = true
		print('Подсветил')
		# Если мы навели на новый объект
		var mat = mesh.get_active_material(0)
		# print(mat)
		if mat is StandardMaterial3D:
			mat.emission_enabled = true
			mat.emission = Color(0, 1, 0) # Зеленая подсветка
			mat.emission_energy_multiplier = 2.0
			
func disable_highlight(mesh):
	if mesh is MeshInstance3D and is_highlighted:
		is_highlighted = false
		print('Отключил')
		# Если мы навели на новый объект
		var mat = mesh.get_active_material(0)
		# print(mat)
		if mat is StandardMaterial3D:
			mat.emission_enabled = false
