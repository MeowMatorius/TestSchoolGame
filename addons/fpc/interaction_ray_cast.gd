extends RayCast3D

@export var prompt: Label
var can_interact: bool = true
var last_object = null
var mesh = null

func _ready() -> void:
	prompt.text = ""
	can_interact = true
	last_object = null
	mesh = null
	
	
func _physics_process(_delta):
	
	if is_colliding():
		var collider = get_collider()
		last_object = collider
		
		if collider is Interactable:
			#collider.is_interacting.connect(write_text)
			mesh = collider.get_child(0) # по индексу получила mesh
			collider.highlight(mesh)
			
			if Input.is_action_pressed("interact") and can_interact:
				can_interact = false
				collider.interact(self)
			
			prompt.text = collider.prompt_message
	else:
		prompt.text = ''
		if last_object != null:
			can_interact = true
			last_object.disable_highlight(last_object.get_child(0))
		
