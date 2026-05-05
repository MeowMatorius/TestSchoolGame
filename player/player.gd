extends CharacterBody3D

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

@export_group("Nodes")
@export var HEAD : Node3D
@export var CAMERA : Node3D 
@export var camera_target: Node3D
@export var COLLISION : CollisionShape3D
@export var CEILING_CHECK : RayCast3D 
@export var FLASHLIGHT : SpotLight3D

@export_group("Base Movement")
@export var base_speed := 3.0
@export var sprint_speed := 6.0
@export var crouch_speed := 1.5      
@export var acceleration := 5.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.1
@export var immobile := false

@export_group("Jump Momentum")
@export var has_jump_momentum := true
@export var air_control := 0.3

@export_group("Directional Sprint")
@export var all_direction_sprint := true
@export var backward_speed_mult := 0.6
@export var side_speed_mult := 0.8

@export_group("Crouch Settings")
@export var crouch_height := 1.0     
@export var crouch_head_y := -0.7    
@export var crouch_transition := 5.0  
@export var crouch_fov_shift := -5.0
@export var crouch_look_limit_angle := 45.0
@export var crouch_bob_amp_mult := 0.5  
@export var crouch_bob_freq_mult := 0.7 

@export_group("Tilt Settings")
@export var tilt_amount := 0.03
@export var mouse_sensitivity_tilt := 0.13
@export var forward_tilt_amount := 0.02
@export var backward_tilt_amount := 0.03
@export var air_tilt_amount := 0.05
@export var tilt_smoothing := 5.0

@export_group("Smoothness (Lerp)")
@export var pos_smoothing := 15.0 
@export var return_speed := 4.0      

@export_group("Landing & Jump")
@export var landing_ebob_amp := 2.0 
@export var jump_tilt_strength := 0.15
@export var shake_strength := 0.1   
@export var shake_decay := 5.0      

@export_group("Bobbing & Idle")
@export var idle_noise_speed := 2.0
@export var idle_noise_amp := 0.01
@export var bob_freq := 3.0
@export var bob_amp_h := 0.05
@export var bob_amp_v := 0.05
@export var bob_roll_amp := 0.0
@export var bob_stop_speed := 3.0 

@export_group("FOV Details")
@export var default_fov := 75.0
@export var fov_shift := 5.0

# Внутренние переменные
var noise_time := 0.0
var was_on_floor := true
var last_velocity_y := 0.0 
var mouse_input_x := 0.0 
var jump_tilt := 0.0 
var target_jump_tilt := 0.0 
var landing_offset := 0.0
var current_shake := 0.0 
var speed := 3.0
var crouch_toggled := false
var is_crouching := false 
var mouse_rotation_x := 0.0 
var current_tilt_z := 0.0
var current_tilt_x := 0.0
var effective_velocity := 0.0 

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var initial_height : float = COLLISION.shape.height 
@onready var initial_head_y : float = HEAD.position.y      


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and not immobile:
		mouse_input_x = event.relative.x 
		HEAD.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var limit = crouch_look_limit_angle if (is_crouching and limit_crouch_look) else 89.0
		mouse_rotation_x -= event.relative.y * mouse_sensitivity
		mouse_rotation_x = clamp(mouse_rotation_x, -limit, limit)
	
	if enable_crouching and toggle_crouch and event.is_action_pressed("crouch"):
		crouch_toggled = !crouch_toggled

	if event.is_action_pressed("flashlight"):
			FLASHLIGHT.visible = !FLASHLIGHT.visible


func _process(delta: float):
	var input_dir = Vector2.ZERO if immobile else Input.get_vector("left", "right", "up", "down")
	var is_sprinting = enable_sprinting and (Input.is_action_pressed("sprint") or auto_sprint) and not is_crouching
	
	handle_visual_effects(delta, input_dir, is_sprinting, is_crouching)
	
	if CAMERA:
		CAMERA.global_transform = camera_target.global_transform


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if enable_jumping and Input.is_action_just_pressed("jump") and is_on_floor() and not immobile:
		velocity.y = jump_velocity
		if enable_landing_effects:
			target_jump_tilt = jump_tilt_strength 

	var input_dir = Vector2.ZERO if immobile else Input.get_vector("left", "right", "up", "down")
	
	if enable_crouching:
		is_crouching = crouch_toggled or (CEILING_CHECK and CEILING_CHECK.is_colliding()) if toggle_crouch else (Input.is_action_pressed("crouch") or (CEILING_CHECK and CEILING_CHECK.is_colliding()))
	else:
		is_crouching = false
		
	process_crouch(delta, is_crouching)
	
	var is_sprinting = enable_sprinting and (Input.is_action_pressed("sprint") or auto_sprint) and not is_crouching
	calculate_speed(input_dir, is_crouching, is_sprinting)
	
	var head_basis = HEAD.global_transform.basis
	var direction = (head_basis.x * input_dir.x + head_basis.z * input_dir.y).normalized()
	direction.y = 0 
	
	if enable_movement_smoothing:
		var accel = acceleration * (air_control if not is_on_floor() and has_jump_momentum else 1.0)
		velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	last_velocity_y = velocity.y
	move_and_slide()

	if is_on_floor() and not was_on_floor:
		if enable_landing_effects:
			var impact_speed = abs(last_velocity_y)
			if impact_speed > 3.0: 
				var impact_factor = remap(clamp(impact_speed, 3.0, 20.0), 3.0, 20.0, 0.2, 1.0)
				landing_offset -= landing_ebob_amp * impact_factor
				target_jump_tilt = -jump_tilt_strength * impact_factor
				current_shake = shake_strength * impact_factor

	was_on_floor = is_on_floor()


func calculate_speed(input_dir, is_crouching, is_sprinting):
	if is_crouching:
		speed = crouch_speed
	elif is_sprinting and (input_dir.length() > 0.01 or effective_velocity > base_speed):
		# Если есть ввод ИЛИ мы еще катимся по инерции на большой скорости
		var mult = backward_speed_mult if input_dir.y > 0 else 1.0
		var side_m = lerp(1.0, side_speed_mult, abs(input_dir.x))
		speed = sprint_speed * mult * side_m
	else:
		speed = base_speed



func process_crouch(delta, crouching):
	var target_h = crouch_height if crouching else initial_height
	var prev_h = COLLISION.shape.height
	COLLISION.shape.height = lerp(COLLISION.shape.height, target_h, delta * crouch_transition)
	var height_diff = COLLISION.shape.height - prev_h
	global_position.y += height_diff / 2.0
	var target_y = initial_head_y + (crouch_head_y if crouching else 0.0)
	HEAD.position.y = lerp(HEAD.position.y, target_y, delta * crouch_transition)


func handle_visual_effects(delta, input_dir, is_sprinting, crouching):
	# 1. Плавная скорость
	var real_speed = Vector2(velocity.x, velocity.z).length()
	var target_effective = real_speed if is_on_floor() else 0.0
	effective_velocity = lerp(effective_velocity, target_effective, delta * bob_stop_speed)
	
	# 2. Таймеры и затухания
	landing_offset = lerp(landing_offset, 0.0, delta * return_speed)
	jump_tilt = lerp(jump_tilt, target_jump_tilt, delta * return_speed * 1.5)
	target_jump_tilt = lerp(target_jump_tilt, 0.0, delta * return_speed)
	current_shake = lerp(current_shake, 0.0, delta * shake_decay)
	
	# 3. Тилт и наклоны
	if enable_tilting:
		var t_z = air_tilt_amount if not is_on_floor() else tilt_amount
		var target_z = (-input_dir.x * t_z) - deg_to_rad(mouse_input_x * mouse_sensitivity_tilt)
		current_tilt_z = lerp(current_tilt_z, target_z, delta * tilt_smoothing)
		
		var target_x = 0.0
		if input_dir.y > 0: target_x = backward_tilt_amount * input_dir.y
		elif input_dir.y < 0: target_x = forward_tilt_amount * input_dir.y * (1.5 if is_sprinting else 1.0)
		current_tilt_x = lerp(current_tilt_x, target_x + jump_tilt, delta * tilt_smoothing)

	mouse_input_x = lerp(mouse_input_x, 0.0, delta * 10.0)

	# 4. РАСШИРЕННЫЙ BOBBING
	var bob_vec = Vector3.ZERO
	var roll_bob = 0.0
	
	if enable_bobbing and effective_velocity > 0.1:
		var f_mult = crouch_bob_freq_mult if crouching else 1.0
		var a_mult = crouch_bob_amp_mult if crouching else 1.0
		noise_time += delta * effective_velocity * bob_freq * f_mult
		
		bob_vec.x = sin(noise_time * 0.5) * bob_amp_h * a_mult
		bob_vec.y = sin(noise_time) * bob_amp_v * a_mult
		# Новый слой Roll
		roll_bob = cos(noise_time * 0.5) * bob_roll_amp * a_mult
	
	if enable_idle_noise:
		var idle_noise_time = Time.get_ticks_msec() * 0.001 * idle_noise_speed
		var idle_vec = Vector3(cos(idle_noise_time * 0.8) * idle_noise_amp, sin(idle_noise_time * 1.2) * idle_noise_amp, 0)
		var idle_weight = clamp(1.0 - (effective_velocity / base_speed), 0.0, 1.0)
		bob_vec = bob_vec.lerp(idle_vec, idle_weight)
	
	if current_shake > 0.01:
		bob_vec.x += randf_range(-current_shake, current_shake)
		bob_vec.y += randf_range(-current_shake, current_shake)
	
	# Применение позиции
	camera_target.position = camera_target.position.lerp(bob_vec + Vector3(0, landing_offset, 0), delta * pos_smoothing)
	
	# ПРИМЕНЕНИЕ ВРАЩЕНИЯ (X + Z)
	HEAD.rotation.z = current_tilt_z + roll_bob
	camera_target.rotation.x = deg_to_rad(mouse_rotation_x) + current_tilt_x
	
	# FOV
	if CAMERA and "fov" in CAMERA and enable_fov_dynamic:
		var air_fov = clamp(abs(velocity.y) * 0.5, 0.0, 10.0) if not is_on_floor() else 0.0
		
		# Проверяем, что персонаж действительно быстро движется по горизонтали
		var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
		var is_actually_running = is_sprinting and horizontal_velocity > (base_speed + 0.1)
		
		# Используем fov_shift только если мы реально бежим
		var target_fov = default_fov + (fov_shift if is_actually_running else 0.0) + (crouch_fov_shift if crouching else 0.0) + air_fov
		
		CAMERA.fov = lerp(float(CAMERA.fov), target_fov, delta * 5.0)
