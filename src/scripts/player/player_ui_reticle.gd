extends Control

@export_category('Прицел')
@export var base_radius: float = 3.0
@export var outline_thickness: float = 1.5
@export var expand_size: float = 6.0
var current_radius: float = 3.0
var tween: Tween

@export_category('Иконки')
@export var icon_size: Vector2 = Vector2(24, 24)

@export var switch_icon: Texture2D
@export var pickup_icon: Texture2D
@export var talk_icon: Texture2D
@export var read_icon: Texture2D

@export_category('Дополнительно')
@export var lock_icon: Texture2D
@export var broken_icon: Texture2D

@export_category('Анимация иконок')
@export var icon_pop_in_duration: float = 0.12
@export var icon_pop_out_duration: float = 0.08
@export var icon_pop_overshoot: float = 1.2

@export_category('Анимация нажатия')
@export var press_icon_expand: float = 0.2
@export var press_icon_in_duration: float = 0.06
@export var press_icon_out_duration: float = 0.18

var current_icon: Texture2D = null
var icon_scale: float = 0.0
var icon_tween: Tween
var press_tween: Tween
var press_boost: float = 0.0


func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS

	SignalBus.interaction_pressed.connect(_on_interact)
	SignalBus.is_targeting_object.connect(_on_targeting_object)
	SignalBus.is_not_targeting_object.connect(_reset_icon)

	current_radius = base_radius


func _on_interact():
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "current_radius", base_radius + expand_size, 0.05)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "current_radius", base_radius, 0.3)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	if current_icon != null:
		_play_press_animation()


func _play_press_animation() -> void:
	if press_tween:
		press_tween.kill()

	press_tween = create_tween()
	
	press_tween.tween_property(self, "press_boost", press_icon_expand, press_icon_in_duration)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	press_tween.tween_property(self, "press_boost", 0.0, press_icon_out_duration)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _on_targeting_object(target_object_interact) -> void:
	var new_icon: Texture2D = null
	match target_object_interact.object_type:
		1: new_icon = pickup_icon
		2:
			if target_object_interact.switch_data.lock_state == target_object_interact.switch_data.LockState.LOCKED:
				new_icon = lock_icon
			elif target_object_interact.switch_data.lock_state == target_object_interact.switch_data.LockState.BROKEN:
				new_icon = broken_icon
			else:
				new_icon = switch_icon
		3: new_icon = talk_icon
		4: new_icon = read_icon
		_: new_icon = null

	_set_icon(new_icon)


func _set_icon(new_icon: Texture2D) -> void:
	if new_icon == current_icon:
		return
	current_icon = new_icon

	if icon_tween:
		icon_tween.kill()
	icon_tween = create_tween()

	if current_icon == null:
		icon_tween.tween_property(self, "icon_scale", 0.0, icon_pop_out_duration)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	else:
		icon_scale = 0.0
		icon_tween.tween_property(self, "icon_scale", icon_pop_overshoot, icon_pop_in_duration * 0.6)\
				.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		icon_tween.tween_property(self, "icon_scale", 1.0, icon_pop_in_duration * 0.4)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _reset_icon():
	_set_icon(null)


func _draw():
	var center: Vector2 = Vector2.ZERO

	if current_icon and icon_scale > 0.01:
		var effective_scale: float = icon_scale + press_boost
		var scaled_size: Vector2 = icon_size * effective_scale
		var half_size: Vector2 = (scaled_size * 0.5).round()
		var icon_rect: Rect2 = Rect2(center - half_size, scaled_size)
		draw_texture_rect(current_icon, icon_rect, false)
	else:
		draw_circle(center, current_radius + outline_thickness, Color.BLACK)
		draw_circle(center, current_radius, Color.WHITE)


func _process(_delta):
	queue_redraw()
