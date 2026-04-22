extends Interactable

@onready var anim_player = $AnimationPlayer
signal opened_door


func _ready() -> void:
	is_opened = false


func open_by_switch():
	is_opened = !is_opened
	print("\n", get_script().resource_path.get_file(), ":\n", name, " открыт: ", is_opened)
	if is_opened:
		opened_door.emit()
		anim_player.play("activate")
	else:
		anim_player.play("deactivate")
