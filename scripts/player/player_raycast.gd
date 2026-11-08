extends RayCast3D

@onready var ui_group: Array[Node] = get_tree().get_nodes_in_group('ui')
# Флаг видимости prompt
@export var show_prompt: bool = true

# Подсказка взаимодействия по умолчанию
var text_prompt: Label
# Информация о текущей цели
var target_object: Node3D = null       # Объект/коллайдер
var target_mesh: MeshInstance3D = null # Меш объекта для шейдеров
var target_interact: Node = null       # InteractComponent объекта для работы с interact


func _ready() -> void:
	text_prompt = ArrayUtilities.find_in_group(ui_group, 'InteractPrompt').get_child(0)
	
	_clear_target()
	SignalBus.interaction_pressed.connect(_on_interaction_pressed)
	SignalBus.object_removed.connect(_clear_target)


# Нажатие кнопки Interact
func _on_interaction_pressed() -> void:
	if is_instance_valid(target_interact) and is_instance_valid(target_object):
		target_interact.interact(target_object)


func _physics_process(_delta: float) -> void:
	# Получение коллайдера
	var collider := get_collider() if is_colliding() else null

	# Подхват InteractComponent только если есть коллайдер
	var interact := _find_interact(collider) \
		if collider \
		else null

	# Сброс при отсутствии цели
	if interact == null:
		_clear_target()
		return

	# Смена цели
	if collider != target_object or interact != target_interact:
		_clear_target()
		target_object = collider
		target_interact = interact
		target_mesh = _find_mesh(collider)
		if target_mesh and interact.has_method("set_shader_effect"):
			interact.set_shader_effect(target_mesh, true)
		SignalBus.is_targeting_object.emit(interact)

	# Prompt синхронизируем каждый кадр
	if text_prompt:
		text_prompt.text = interact.get_prompt()
		text_prompt.visible = show_prompt


# Проверка наличия InteractComponent у объекта
func _find_interact(collider: Object) -> Node:
	var target_collider := collider as Node
	while target_collider:
		if target_collider.has_meta("is_being_removed"): # видеть pickup ещё до фактического queue_free()
			return null
		if target_collider.has_node("InteractComponent"):
			return target_collider.get_node("InteractComponent")
		target_collider = target_collider.get_parent()
	return null


# Проверка наличия MeshInstance3D у объекта
func _find_mesh(node: Node) -> MeshInstance3D:
	var found := node.find_children("*", "MeshInstance3D", true, false)
	return found[0] if found.size() > 0 else null


# Полный сброс цели
func _clear_target() -> void:
	# Снимаем шейдер только если объект еще существует
	if is_instance_valid(target_interact) and is_instance_valid(target_mesh) \
			and target_interact.has_method("set_shader_effect"):
		target_interact.set_shader_effect(target_mesh, false)

	# Храним в памяти информацию о цели (Для проверки была или нет)
	var had_target := target_object != null or target_interact != null
	target_object = null
	target_interact = null
	target_mesh = null

	# Prompt чистится даже если цели не было
	if text_prompt:
		text_prompt.text = ""
		text_prompt.visible = false

	if had_target:
		SignalBus.is_not_targeting_object.emit()
