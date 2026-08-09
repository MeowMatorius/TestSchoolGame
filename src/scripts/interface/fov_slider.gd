extends HBoxContainer

@export var slider: HSlider
@export var line_edit: LineEdit

@export var min_fov: int = 50
@export var max_fov: int = 100

func _ready() -> void:
	line_edit.text = str(SettingsManager.global_fov)
	
	slider.max_value = max_fov
	slider.min_value = min_fov
	slider.value = SettingsManager.global_fov

func _on_fov_slider_value_changed(value: float) -> void:
	line_edit.text = str(int(value))
	_set_global_fov(int(value))


func _on_fov_edit_text_submitted(new_text: String) -> void:
	var value: int = new_text.to_int()
	value = clamp(value, min_fov, max_fov)
	slider.value = value
	line_edit.text = str(round(value))
	_set_global_fov(int(value))


func _set_global_fov(new_value:int):
	SettingsManager.global_fov = new_value
