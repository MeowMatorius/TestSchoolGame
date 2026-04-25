extends Interactable

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_opened: bool = false


func _ready() -> void:
	is_opened = false


func open_by_switch():
	is_opened = !is_opened
	if is_opened:
		anim_player.play("activate")
	else:
		anim_player.play("deactivate")
