extends Control

@export var base_radius: float = 3.0       # Радиус точки в покое
@export var outline_thickness: float = 1.5 # Толщина черной обводки
@export var expand_size: float = 6.0       # На сколько пикселей расширяется точка

var current_radius: float = 3.0            # Текущий радиус для анимации
var tween: Tween


func _ready():
	# Подключаемся к вашему сигналу
	InputManager.interaction_pressed.connect(_on_interact)
	current_radius = base_radius


func _on_interact():
	if tween:
		tween.kill()
	
	tween = create_tween()
	# Быстрое расширение
	tween.tween_property(self, "current_radius", base_radius + expand_size, 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Плавный возврат
	tween.tween_property(self, "current_radius", base_radius, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _draw():
	var center = Vector2.ZERO
	
	# Рисуем черную обводку (радиус точки + толщина обводки)
	draw_circle(center, current_radius + outline_thickness, Color.BLACK)
	
	# Рисуем саму белую точку
	draw_circle(center, current_radius, Color.WHITE)


func _process(_delta):
	queue_redraw()
