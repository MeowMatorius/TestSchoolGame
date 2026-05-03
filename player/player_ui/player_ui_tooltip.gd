extends Label
var tween: Tween

func _ready() -> void:
	InventoryManager.add_to_inventory.connect(_on_tooltip_updated)

func _on_tooltip_updated(item_data):
	text = 'Получено ' + str(item_data.quantity) + ' ' + item_data.name
	if tween:
		tween.kill()
	
	# 1. Делаем текст видимым мгновенно (или плавно)
	modulate.a = 1.0
	
	# 2. Создаем новый Tween
	tween = create_tween()
	
	# 3. Ждем 3 секунды внутри Tween (задержка перед исчезновением)
	tween.tween_interval(3.0)
	
	# 4. Плавно скрываем за 1 секунду
	tween.tween_property(self, "modulate:a", 0.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
