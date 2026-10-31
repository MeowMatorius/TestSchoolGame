class_name Interact
extends Node

enum ObjectType { NONE, PICKUP, SWITCH, TALK, READ }
@export var object_type: ObjectType = ObjectType.NONE

var highlighted: bool = false
@export var commands: Array[CommandData]


func trigger_command():
	for i in commands:
		# Фабрика создает команду, используя тип из ресурса и прикрепленный квест
		var command := CommandFactory.create_command(i.command_type,i)
		if command: command.execute(get_tree())


func _ready() -> void:
	highlighted = false


func set_shader_effect(mesh: MeshInstance3D, enabled: bool) -> void:
	var next: Material = null
	
	if mesh and mesh.material_override and mesh.material_override.next_pass:
		next = mesh.material_override.next_pass
	else: return

	if next is ShaderMaterial:
		next.set_shader_parameter("effect_strength", 1.0 if enabled else 0.0)
