extends RayCast3D

@export var text_prompt: Label
var last_object = null
var last_object_mesh = null


func _ready() -> void:
	last_object = null
	last_object_mesh = null
	
	text_prompt.text = ""


func _physics_process(_delta):
	
	if is_colliding() and get_collider() is Interactable:
		last_object = get_collider()
		last_object_mesh = last_object.get_node("MeshInstance3D")
		
		text_prompt.text = last_object.prompt_message
		last_object.highlight(last_object_mesh, last_object.name)
		
		if Input.is_action_just_pressed("interact"):
			last_object.interact()
	else:
		text_prompt.text = ''
		if last_object != null:
			last_object.disable_highlight(last_object.get_child(0), last_object.name)
		
