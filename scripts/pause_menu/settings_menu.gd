extends Control

@onready var world_env: WorldEnvironment = get_tree().get_first_node_in_group("world_env")
var camera: CameraAttributesPractical
var enviroment: Environment

@export var letterbox_panel_up: Panel
@export var letterbox_panel_down: Panel


func _ready():
	enviroment = world_env.environment
	camera = world_env.camera_attributes
	setup_settings_menu()


func setup_settings_menu():
	for button in find_children("*", "CheckButton", true):
		button.pressed.connect(_on_setting_changed.bind(button.name))
		print ("connected to: ", button.name)


func _on_setting_changed(setting_name: String):
	match setting_name:
		"LetterboxButton":
			letterbox_panel_up.visible = !letterbox_panel_up.visible
			letterbox_panel_down.visible = !letterbox_panel_down.visible
		"VolumetricFogButton":
			enviroment.volumetric_fog_enabled = !enviroment.volumetric_fog_enabled
		"BloomButton":
			enviroment.glow_enabled = !enviroment.glow_enabled
		"SSAOButton":
			enviroment.ssao_enabled = !enviroment.ssao_enabled
		"SSRButton":
			enviroment.ssr_enabled = !enviroment.ssr_enabled
		"SSILButton":
			enviroment.ssil_enabled = !enviroment.ssil_enabled
		"SDFGIButton":
			enviroment.sdfgi_enabled = !enviroment.sdfgi_enabled
