extends RayCast3D

@export var text_prompt: Label
var target_object = null
var target_object_mesh = null
var target_object_interact = null


func _ready() -> void:
	text_prompt.text = ""
	text_prompt.visible = false
	target_object = null
	target_object_mesh = null


func _physics_process(_delta):
	var collider = get_collider() if is_colliding() else null
	
	if collider:
		if target_object != collider:
			_update_target(collider)
		
		text_prompt.text = "%s\n%s" % [target_object.name, target_object_interact.get_prompt()]
		text_prompt.visible = true
	elif target_object:
		_clear_target()


func _update_target(new_target):
	target_object = new_target
	target_object_interact = target_object.get_node("InteractComponent")
	
	if target_object_interact.has_signal("object_removed"):
		if not target_object_interact.object_removed.is_connected(_clear_target):
			target_object_interact.object_removed.connect(_clear_target)
		
	target_object_mesh = target_object.find_children("*", "MeshInstance3D")[0]
	target_object_interact.highlight(target_object_mesh)


func _clear_target():
	if is_instance_valid(target_object_interact):
		target_object_interact.disable_highlight(target_object_mesh)
		target_object = null
		text_prompt.visible = false


func _unhandled_input(event : InputEvent):
	if is_colliding() and (GameManager.current_game_state == GameManager.game_state.Default):
		if event.is_action_pressed("interact"):
			print("\n", get_script().resource_path.get_file(), "\n", "Нажали Interact на: ", target_object)
			target_object_interact.interact(target_object)
			get_viewport().set_input_as_handled()
