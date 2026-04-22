extends RayCast3D

@export var text_prompt: Label
var last_object = null
var last_object_mesh = null
var last_object_collision = null


func _ready() -> void:
	last_object = null
	last_object_mesh = null
	last_object_collision = null
	
	text_prompt.text = ""


func _physics_process(_delta):
	
	if is_colliding() and get_collider() is Interactable:
		last_object = get_collider()
		# TODO Наводка происходит бесконечно (Хз проблема ли, но коммент оставлю)
		# print("\n", get_script().resource_path.get_file(), ":\n", "Навелись на объект: ", last_object)
		last_object_mesh = last_object.find_children("*", "MeshInstance3D")
		text_prompt.text = last_object.prompt_message
		text_prompt.visible = true
		last_object.highlight(last_object_mesh[0], last_object.name)
		
		if Input.is_action_just_pressed("interact"):
			print("\n", get_script().resource_path.get_file(), ":\n", "Нажали Interact на: ", last_object)
			last_object.interact(last_object)
	else:
		text_prompt.text = ''
		text_prompt.visible = false
		if last_object != null:
			last_object.disable_highlight(last_object_mesh[0], last_object.name)
		
