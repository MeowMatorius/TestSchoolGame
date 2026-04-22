extends RayCast3D

@export var text_prompt: Label
var target_object = null
var target_object_mesh = null
var target_object_collision = null


func _ready() -> void:
	target_object = null
	target_object_mesh = null
	target_object_collision = null
	
	text_prompt.text = ""


func _physics_process(_delta):
	
	if is_colliding() and get_collider() is Interactable:
		target_object = get_collider()
		target_object_mesh = target_object.find_children("*", "MeshInstance3D")
		# FIXME Наводка происходит бесконечно (Пока не проблема)
		# print("\n", get_script().resource_path.get_file(), ":\n", "Навелись на объект: ", target_object)
		
		text_prompt.visible = true
		
		match target_object.object_type:
			"Switch", "Activate":
				match target_object.lock_state:
					"Locked":
						if target_object.item_needed_to_open not in Inventory.items:
							text_prompt.text = str(target_object.name, "\n Закрыто. Требуется: ", target_object.item_needed_to_open)
						else:
							text_prompt.text = str(target_object.name, "\n Открыть с помощью: ", target_object.item_needed_to_open)
					"Broken":
						text_prompt.text = str(target_object.name, "\n Замок сломан")
					_:
						if target_object.object_state == "Deactivated":
							text_prompt.text = str(target_object.name, "\n", target_object.activate_prompt_message)
						elif target_object.object_state == "Activated":
							text_prompt.text = str(target_object.name, "\n", target_object.deactivate_prompt_message)
			"Pickup":
				text_prompt.text = str("Взять\n", target_object.pickup_item_name)
			_:
				pass
		
		target_object.highlight(target_object_mesh[0], target_object.name)
		
		if Input.is_action_just_pressed("interact") and target_object.lock_state != "Broken":
			print("\n", get_script().resource_path.get_file(), "\n", "Нажали Interact на: ", target_object)
			target_object.interact(target_object)
	else:
		text_prompt.text = ''
		text_prompt.visible = false
		if target_object != null:
			target_object.disable_highlight(target_object_mesh[0], target_object.name)
		
