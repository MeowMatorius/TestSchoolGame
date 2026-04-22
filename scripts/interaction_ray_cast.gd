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
		last_object_mesh = last_object.find_children("*", "MeshInstance3D")
		# FIXME Наводка происходит бесконечно (Пока не проблема)
		# print("\n", get_script().resource_path.get_file(), ":\n", "Навелись на объект: ", last_object)
		
		text_prompt.visible = true
		
		match last_object.object_type:
			"Switch", "Activate":
				match last_object.lock_state:
					"Locked":
						if last_object.item_needed_to_open not in Inventory.items:
							text_prompt.text = str(last_object.name, "\n Закрыто. Требуется: ", last_object.item_needed_to_open)
						else:
							text_prompt.text = str(last_object.name, "\n Открыть с помощью: ", last_object.item_needed_to_open)
					"Broken":
						text_prompt.text = str(last_object.name, "\n Замок сломан")
					_:
						if last_object.object_state == "Deactivated":
							text_prompt.text = str(last_object.name, "\n", last_object.activate_prompt_message)
						elif last_object.object_state == "Activated":
							text_prompt.text = str(last_object.name, "\n", last_object.deactivate_prompt_message)
			"Pickup":
				text_prompt.text = str("Взять\n", last_object.pickup_item_name)
			_:
				pass
		
		last_object.highlight(last_object_mesh[0], last_object.name)
		
		if Input.is_action_just_pressed("interact") and last_object.lock_state != "Broken":
			print("\n", get_script().resource_path.get_file(), "\n", "Нажали Interact на: ", last_object)
			last_object.interact(last_object)
	else:
		text_prompt.text = ''
		text_prompt.visible = false
		if last_object != null:
			last_object.disable_highlight(last_object_mesh[0], last_object.name)
		
