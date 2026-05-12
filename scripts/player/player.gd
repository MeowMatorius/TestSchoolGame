extends CharacterBody3D

#region Feature Flags
@export_group("Feature Flags")
@export var enable_jumping := true
@export var enable_crouching := true
@export var toggle_crouch := true
@export var enable_sprinting := true
@export var auto_sprint := false
@export var enable_movement_smoothing := true
@export var enable_bobbing := true
@export var enable_idle_noise := true
@export var enable_tilting := true
@export var limit_crouch_look := false
@export var enable_landing_effects := true
@export var enable_fov_dynamic := true
#endregion

#region Nodes
@export_group("Nodes")
@export var HEAD : Node3D
@export var CAMERA : Node3D
@export var camera_target: Node3D
@export var COLLISION : CollisionShape3D
@export var CEILING_CHECK : RayCast3D
@export var FLASHLIGHT : SpotLight3D
#endregion

#region Base Movement
@export_group("Base Movement")
@export var base_speed := 3.0
@export var sprint_speed := 6.0
@export var crouch_speed := 1.5
@export var acceleration := 5.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.1
@export var immobile := false
#endregion

#region Jump Momentum
@export_group("Jump Momentum")
@export var has_jump_momentum := true
@export var air_control := 0.3
#endregion

#region Directional Speed Multipliers (применяются ко всем типам движения)
@export_group("Directional Speed")
@export var all_direction_sprint := true
@export var backward_speed_mult := 0.6
@export var side_speed_mult := 0.8
#endregion

#region Crouch Settings
@export_group("Crouch Settings")
@export var crouch_height := 1.0
@export var crouch_head_y := -0.7
@export var crouch_transition := 5.0
@export var crouch_fov_shift := -5.0
@export var crouch_look_limit_angle := 45.0
@export var crouch_bob_amp_mult := 0.5
@export var crouch_bob_freq_mult := 0.7
#endregion

#region Tilt Settings
@export_group("Tilt Settings")
@export var tilt_amount := 0.03
@export var mouse_sensitivity_tilt := 0.13
@export var forward_tilt_amount := 0.02
@export var backward_tilt_amount := 0.03
@export var air_tilt_amount := 0.05
@export var tilt_smoothing := 5.0
#endregion

#region Smoothness (Lerp)
@export_group("Smoothness (Lerp)")
@export var pos_smoothing := 15.0
@export var return_speed := 4.0
#region Landing & Jump
@export_group("Landing & Jump")
@export var landing_ebob_amp := 2.0
@export var jump_tilt_strength := 0.15
@export var shake_strength := 0.1
@export var shake_decay := 5.0
#endregion

#region Bobbing & Idle
@export_group("Bobbing & Idle")
@export var idle_noise_speed := 2.0
@export var idle_noise_amp := 0.01
@export var bob_freq := 3.0
@export var bob_amp_h := 0.05
@export var bob_amp_v := 0.05
@export var bob_roll_amp := 0.0
@export var bob_stop_speed := 3.0
#endregion

#region Sprint Bobbing Multipliers
@export_group("Sprint Bobbing")
@export var sprint_bob_h_mult := 1.5
@export var sprint_bob_v_mult := 1.8
@export var sprint_bob_roll_mult := 2.0
@export var sprint_bob_freq_mult := 1.3
#endregion

#region FOV Details
@export_group("FOV Details")
@export var default_fov := 75.0
@export var fov_shift := 5.0
@export var fov_lerp_speed := 5.0
#endregion

#region Internal Constants
const MOUSE_INPUT_DECAY := 10.0
const JUMP_TILT_RETURN_MULT := 1.5
const LANDING_SPEED_THRESHOLD := 3.0
const LANDING_SPEED_MAX := 20.0
const AIR_FOV_FACTOR := 0.5
const AIR_FOV_MAX := 10.0
const SPRINT_BOB_TRANSITION_SPEED := 8.0
#endregion

#region Action Strings
const ACTION_LEFT = "left"
const ACTION_RIGHT = "right"
const ACTION_UP = "up"
const ACTION_DOWN = "down"
const ACTION_JUMP = "jump"
const ACTION_SPRINT = "sprint"
const ACTION_CROUCH = "crouch"
const ACTION_FLASHLIGHT = "flashlight"
#endregion

#region State Variables
var noise_time: float = 0.0
var was_on_floor: bool = true
var last_velocity_y: float = 0.0
var mouse_input_x: float = 0.0
var jump_tilt: float = 0.0
var target_jump_tilt: float = 0.0
var landing_offset: float = 0.0
var current_shake: float = 0.0
var speed: float = 3.0
var crouch_toggled: bool = false
var is_crouching: bool = false
var mouse_rotation_x: float = 0.0
var current_tilt_z: float = 0.0
var current_tilt_x: float = 0.0
var smoothed_horizontal_speed: float = 0.0
var sprint_bob_factor: float = 0.0
#endregion

#region Onready
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") as float
@onready var initial_height: float = COLLISION.shape.height if COLLISION else 0.0
@onready var initial_head_y: float = HEAD.position.y if HEAD else 0.0
#endregion

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if not is_instance_valid(HEAD):
		push_error("HEAD node not assigned!")
	if not is_instance_valid(camera_target):
		push_error("camera_target node not assigned!")
	if not is_instance_valid(COLLISION):
		push_error("COLLISION node not assigned!")
	if not is_instance_valid(CAMERA):
		print("CAMERA not assigned – FOV and camera snapping will be ignored")
	if not is_instance_valid(FLASHLIGHT):
		print("FLASHLIGHT not assigned – flashlight toggle will have no effect")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not immobile:
		mouse_input_x = event.relative.x
		if is_instance_valid(HEAD):
			HEAD.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var limit: float = crouch_look_limit_angle if (is_crouching and limit_crouch_look) else 89.0
		mouse_rotation_x -= event.relative.y * mouse_sensitivity
		mouse_rotation_x = clamp(mouse_rotation_x, -limit, limit)

	if enable_crouching and toggle_crouch and event.is_action_pressed(ACTION_CROUCH):
		crouch_toggled = not crouch_toggled

	if event.is_action_pressed(ACTION_FLASHLIGHT) and is_instance_valid(FLASHLIGHT):
		FLASHLIGHT.visible = not FLASHLIGHT.visible

func _process(delta: float) -> void:
	if is_instance_valid(CAMERA) and is_instance_valid(camera_target):
		CAMERA.global_transform = camera_target.global_transform

func _physics_process(delta: float) -> void:
	if not is_instance_valid(HEAD) or not is_instance_valid(camera_target) or not is_instance_valid(COLLISION):
		return

	var input_dir := Vector2.ZERO if immobile else Input.get_vector(ACTION_LEFT, ACTION_RIGHT, ACTION_UP, ACTION_DOWN)

	apply_gravity(delta)

	if enable_jumping and Input.is_action_just_pressed(ACTION_JUMP) and is_on_floor() and not immobile:
		velocity.y = jump_velocity
		if enable_landing_effects:
			target_jump_tilt = jump_tilt_strength

	update_crouch_state()
	process_crouch(delta, is_crouching)

	var is_sprinting: bool = enable_sprinting and (Input.is_action_pressed(ACTION_SPRINT) or auto_sprint) and not is_crouching
	calculate_speed(input_dir, is_sprinting)

	var direction: Vector3 = calculate_move_direction(input_dir)
	apply_movement(delta, direction, is_sprinting)

	last_velocity_y = velocity.y
	move_and_slide()

	detect_landing()
	update_visual_effects(delta, input_dir, is_sprinting, is_crouching)

	was_on_floor = is_on_floor()

#region Physics sub-functions
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func update_crouch_state() -> void:
	if not enable_crouching:
		is_crouching = false
		return
	if toggle_crouch:
		if is_instance_valid(CEILING_CHECK) and CEILING_CHECK.is_colliding():
			is_crouching = true
		else:
			is_crouching = crouch_toggled
	else:
		is_crouching = Input.is_action_pressed(ACTION_CROUCH) or (is_instance_valid(CEILING_CHECK) and CEILING_CHECK.is_colliding())

func calculate_move_direction(input_dir: Vector2) -> Vector3:
	if not is_instance_valid(HEAD):
		return Vector3.ZERO
	var head_basis: Basis = HEAD.global_transform.basis
	var direction: Vector3 = head_basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0
	return direction.normalized()

func apply_movement(delta: float, direction: Vector3, is_sprinting: bool) -> void:
	if enable_movement_smoothing:
		var control_factor: float = air_control if (not is_on_floor() and has_jump_momentum) else 1.0
		var accel: float = acceleration * control_factor
		velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

func detect_landing() -> void:
	if not is_on_floor() or was_on_floor:
		return
	if not enable_landing_effects:
		return

	var impact_speed: float = abs(last_velocity_y)
	if impact_speed > LANDING_SPEED_THRESHOLD:
		var impact_factor: float = remap(clamp(impact_speed, LANDING_SPEED_THRESHOLD, LANDING_SPEED_MAX),
				LANDING_SPEED_THRESHOLD, LANDING_SPEED_MAX, 0.2, 1.0) as float
		landing_offset -= landing_ebob_amp * impact_factor
		target_jump_tilt = -jump_tilt_strength * impact_factor
		current_shake = shake_strength * impact_factor
#endregion

#region Speed & Crouch Processing
func calculate_speed(input_dir: Vector2, is_sprinting: bool) -> void:
	# Определяем базовую скорость в зависимости от состояния
	var base_movement_speed: float
	if is_crouching:
		base_movement_speed = crouch_speed
	elif is_sprinting:
		base_movement_speed = sprint_speed
	else:
		base_movement_speed = base_speed
	
	# Ограничение спринта только вперёд если all_direction_sprint выключен
	if is_sprinting and not all_direction_sprint and input_dir.y >= 0:
		base_movement_speed = base_speed
	
	# Проверка инерции для спринта
	if is_sprinting and input_dir.length() <= 0.01 and smoothed_horizontal_speed <= base_speed:
		base_movement_speed = base_speed
	
	# Применяем направленные множители ко ВСЕМ типам движения
	var mult: float = backward_speed_mult if input_dir.y > 0 else 1.0
	var side_m: float = lerp(1.0, side_speed_mult, abs(input_dir.x)) as float
	
	speed = base_movement_speed * mult * side_m

func process_crouch(delta: float, crouching: bool) -> void:
	if not is_instance_valid(COLLISION) or not is_instance_valid(HEAD):
		return
	var target_h: float = crouch_height if crouching else initial_height
	var prev_h: float = COLLISION.shape.height
	COLLISION.shape.height = lerp(COLLISION.shape.height, target_h, delta * crouch_transition)
	var height_diff: float = COLLISION.shape.height - prev_h
	global_position.y += height_diff / 2.0
	var target_y: float = initial_head_y + (crouch_head_y if crouching else 0.0)
	HEAD.position.y = lerp(HEAD.position.y, target_y, delta * crouch_transition)
#endregion

#region Full Visual Effects
func update_visual_effects(delta: float, input_dir: Vector2, is_sprinting: bool, crouching: bool) -> void:
	if not is_instance_valid(HEAD) or not is_instance_valid(camera_target):
		return

	var real_speed: float = Vector2(velocity.x, velocity.z).length()
	var target_smooth: float = real_speed if is_on_floor() else 0.0
	smoothed_horizontal_speed = lerp(smoothed_horizontal_speed, target_smooth, delta * bob_stop_speed)

	# Плавный переход спринт-фактора для боббинга
	update_sprint_bob_factor(delta, is_sprinting)

	apply_decay(delta)

	if enable_tilting:
		update_tilt(delta, input_dir, is_sprinting)

	mouse_input_x = lerp(mouse_input_x, 0.0, delta * MOUSE_INPUT_DECAY)

	var bobbing_data: Dictionary = calculate_bobbing(delta, crouching)
	var bob_offset: Vector3 = bobbing_data["offset"]
	var roll_bob: float = bobbing_data["roll"]

	if current_shake > 0.01:
		bob_offset.x += randf_range(-current_shake, current_shake)
		bob_offset.y += randf_range(-current_shake, current_shake)

	var target_pos: Vector3 = bob_offset + Vector3(0, landing_offset, 0)
	camera_target.position = camera_target.position.lerp(target_pos, 1.0 - exp(-pos_smoothing * delta))

	HEAD.rotation.z = current_tilt_z + roll_bob
	camera_target.rotation.x = deg_to_rad(mouse_rotation_x) + current_tilt_x

	update_fov(delta, crouching, is_sprinting)

func update_sprint_bob_factor(delta: float, is_sprinting: bool) -> void:
	# Определяем целевую интенсивность спринта
	var horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	var is_actually_sprinting: bool = is_sprinting and horizontal_speed > (base_speed + 0.5)
	var target_factor: float = 1.0 if is_actually_sprinting else 0.0
	
	# Плавный переход между обычной ходьбой и спринтом
	sprint_bob_factor = lerp(sprint_bob_factor, target_factor, delta * SPRINT_BOB_TRANSITION_SPEED)

func apply_decay(delta: float) -> void:
	landing_offset = lerp(landing_offset, 0.0, delta * return_speed)
	jump_tilt = lerp(jump_tilt, target_jump_tilt, delta * return_speed * JUMP_TILT_RETURN_MULT)
	target_jump_tilt = lerp(target_jump_tilt, 0.0, delta * return_speed)
	current_shake = lerp(current_shake, 0.0, delta * shake_decay)

func update_tilt(delta: float, input_dir: Vector2, is_sprinting: bool) -> void:
	var t_z: float = air_tilt_amount if not is_on_floor() else tilt_amount
	var target_z: float = (-input_dir.x * t_z) - deg_to_rad(mouse_input_x * mouse_sensitivity_tilt)
	current_tilt_z = lerp(current_tilt_z, target_z, delta * tilt_smoothing)

	var target_x: float = 0.0
	if input_dir.y > 0:
		target_x = backward_tilt_amount * input_dir.y
	elif input_dir.y < 0:
		target_x = forward_tilt_amount * input_dir.y * (1.5 if is_sprinting else 1.0)
	current_tilt_x = lerp(current_tilt_x, target_x + jump_tilt, delta * tilt_smoothing)

func calculate_bobbing(delta: float, crouching: bool) -> Dictionary:
	var bob_vec: Vector3 = Vector3.ZERO
	var roll: float = 0.0

	# Боббинг при движении с усилением для спринта
	if enable_bobbing and smoothed_horizontal_speed > 0.1:
		var f_mult: float = crouch_bob_freq_mult if crouching else 1.0
		var a_mult: float = crouch_bob_amp_mult if crouching else 1.0
		
		# Применяем множители спринта с плавной интерполяцией
		var sprint_h_mult: float = lerp(1.0, sprint_bob_h_mult, sprint_bob_factor)
		var sprint_v_mult: float = lerp(1.0, sprint_bob_v_mult, sprint_bob_factor)
		var sprint_r_mult: float = lerp(1.0, sprint_bob_roll_mult, sprint_bob_factor)
		var sprint_f_mult: float = lerp(1.0, sprint_bob_freq_mult, sprint_bob_factor)
		
		noise_time += delta * smoothed_horizontal_speed * bob_freq * f_mult * sprint_f_mult
		noise_time = fmod(noise_time, 2.0 * PI)
		
		# Горизонтальное смещение с усилением спринта
		bob_vec.x = sin(noise_time) * bob_amp_h * a_mult * sprint_h_mult
		# Вертикальное смещение (двойная частота) с усилением спринта
		bob_vec.y = sin(noise_time * 2.0) * bob_amp_v * a_mult * sprint_v_mult
		# Roll с усилением спринта
		roll = sin(noise_time) * bob_roll_amp * a_mult * sprint_r_mult

	# Idle шум
	if enable_idle_noise:
		var ticks: float = Time.get_ticks_msec() * 0.001
		var idle_time: float = ticks * idle_noise_speed
		var idle_vec: Vector3 = Vector3(
			cos(idle_time * 0.8) * idle_noise_amp,
			sin(idle_time * 1.2) * idle_noise_amp,
			0.0
		)
		var idle_weight: float = clamp(1.0 - (smoothed_horizontal_speed / base_speed), 0.0, 1.0) as float
		bob_vec = bob_vec.lerp(idle_vec, idle_weight)

	return {"offset": bob_vec, "roll": roll}

func update_fov(delta: float, crouching: bool, is_sprinting: bool) -> void:
	if not enable_fov_dynamic or not is_instance_valid(CAMERA) or not "fov" in CAMERA:
		return

	var air_fov: float = 0.0
	if not is_on_floor():
		air_fov = clamp(abs(velocity.y) * AIR_FOV_FACTOR, 0.0, AIR_FOV_MAX) as float

	var horizontal_speed: float = Vector2(velocity.x, velocity.z).length()
	var is_actually_running: bool = is_sprinting and horizontal_speed > (base_speed + 0.1)

	var target_fov: float = default_fov
	if is_actually_running:
		target_fov += fov_shift
	if crouching:
		target_fov += crouch_fov_shift
	target_fov += air_fov

	CAMERA.fov = lerp(float(CAMERA.fov), target_fov, delta * fov_lerp_speed) as float
#endregion
