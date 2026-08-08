extends Control

@onready var world_env: WorldEnvironment = get_tree().get_first_node_in_group("world_env")
var camera: CameraAttributesPractical
var environment: Environment


func _ready() -> void:
	if not world_env or not world_env.environment:
		push_error("WorldEnvironment or Environment resource missing!")
		return
	
	environment = world_env.environment
	camera = world_env.camera_attributes
	setup_settings_menu()


func setup_settings_menu() -> void:
	set_all_environment_effects(true)

	for button in find_children("*", "CheckButton", true):
		var check_btn := button as CheckButton
		if not check_btn:
			continue
			
		sync_button_state(check_btn)
		check_btn.toggled.connect(_on_setting_toggled.bind(check_btn))


func sync_button_state(button: CheckButton) -> void:
	match button.name:
		"VolumetricFogButton": button.button_pressed = environment.volumetric_fog_enabled
		"BloomButton": button.button_pressed = environment.glow_enabled
		"SSAOButton": button.button_pressed = environment.ssao_enabled
		"SSRButton": button.button_pressed = environment.ssr_enabled
		"SSILButton": button.button_pressed = environment.ssil_enabled
		"SDFGIButton": button.button_pressed = environment.sdfgi_enabled


func _on_setting_toggled(toggled_on: bool, button: CheckButton) -> void:
	match button.name:
		"AllButton":
			set_all_environment_effects(toggled_on)
			for child in find_children("*", "CheckButton", true):
				if child.name != "AllButton":
					(child as CheckButton).button_pressed = toggled_on

		"VolumetricFogButton": environment.volumetric_fog_enabled = toggled_on
		"BloomButton": environment.glow_enabled = toggled_on
		"SSAOButton": environment.ssao_enabled = toggled_on
		"SSRButton": environment.ssr_enabled = toggled_on
		"SSILButton": environment.ssil_enabled = toggled_on
		"SDFGIButton": environment.sdfgi_enabled = toggled_on


func set_all_environment_effects(enabled: bool) -> void:
	environment.volumetric_fog_enabled = enabled
	environment.glow_enabled = enabled
	environment.ssao_enabled = enabled
	environment.ssr_enabled = enabled
	environment.ssil_enabled = enabled
	environment.sdfgi_enabled = enabled
