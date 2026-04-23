extends RayCast3D

@export var text_prompt: Label
var target_object = null
var target_object_mesh = null
var target_object_interact = null
var target_object_script = null


func _ready() -> void:
	text_prompt.text = ""
	target_object = null
	target_object_mesh = null
	target_object_script = null


func _physics_process(_delta):
	
	if is_colliding():
		target_object = get_collider()
		target_object_mesh = target_object.find_children("*", "MeshInstance3D")
		target_object_interact = target_object.get_node("InteractComponent")
		target_object_script = target_object_interact.get_script().resource_path.get_file()
		
		text_prompt.visible = true
		target_object_interact.highlight(target_object_mesh[0])
		
		match target_object_script:
			"interact_switch.gd":
				match target_object_interact.lock_state:
					"Locked":
						if target_object_interact.item_needed_to_open not in InventoryManager.items:
							text_prompt.text = str(target_object.name, "\n Закрыто. Требуется: ", target_object_interact.item_needed_to_open)
						else:
							text_prompt.text = str(target_object.name, "\n Открыть с помощью: ", target_object_interact.item_needed_to_open)
					"Broken":
						text_prompt.text = str(target_object.name, "\n Замок сломан")
					_:
						if target_object_interact.object_state == "Deactivated":
							text_prompt.text = str(target_object.name, "\n", target_object_interact.activate_prompt_message)
						elif target_object_interact.object_state == "Activated":
							text_prompt.text = str(target_object.name, "\n", target_object_interact.deactivate_prompt_message)
			"interact_pickup.gd":
				text_prompt.text = str(target_object_interact.pickup_item_name, "\nПодобрать" )
			"interact_talk.gd":
				text_prompt.text = str(target_object.name, "\nПоговорить" )
			_:
				pass

		if Input.is_action_just_pressed("interact") and !GameManager.game_paused:
			print("\n", get_script().resource_path.get_file(), "\n", "Нажали Interact на: ", target_object)
			target_object_interact.interact(target_object)
	else:
		text_prompt.text = ''
		text_prompt.visible = false
		if target_object != null:
			target_object_interact.disable_highlight(target_object_mesh[0])
		
