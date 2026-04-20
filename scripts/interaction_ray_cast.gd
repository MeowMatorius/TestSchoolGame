extends RayCast3D

@export var prompt: Label
var can_interact: bool = true
var can_focus: bool = true
var last_object = null
var mesh = null
var door

func _ready() -> void:
	prompt.text = ""
	can_interact = true
	can_focus = true
	last_object = null
	mesh = null
	door = true
	
func _physics_process(_delta):
	
	if is_colliding():
		var collider = get_collider()
		last_object = collider
		
		if collider is Interactable:
			if can_focus:
				#collider.is_interacting.connect(write_text)
				mesh = collider.get_child(0) # по индексу получила mesh
				collider.highlight(mesh)
				prompt.text = collider.prompt_message
				can_focus = false
			
			if door:
				if Input.is_action_pressed("interact") :	
					if can_interact:
						door = collider.interact(self)
				
				
	else:
		prompt.text = ''
		if last_object != null:
			can_focus = true
			
			last_object.disable_highlight(last_object.get_child(0))
		
