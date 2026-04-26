extends CharacterBody3D

@export_group("Nodes")
@export var HEAD : Node3D
@export var CAMERA : Node3D 
@export var camera_target: Node3D
@export var COLLISION : CollisionShape3D
@export var CEILING_CHECK : RayCast3D 

@export_group("Base Movement")
@export var base_speed := 3.0
@export var sprint_speed := 6.0
@export var crouch_speed := 1.5      
@export var acceleration := 10.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.1
@export var immobile := false

@export_group("Jump Momentum")
@export var has_jump_momentum := true # Флаг инерции прыжка
@export var air_control := 0.3         # Насколько сильно можно менять вектор в воздухе (0.0 - 1.0)

@export_group("Directional Sprint")
@export var all_direction_sprint := true
@export var backward_speed_mult := 0.6
@export var side_speed_mult := 0.8

@export_group("Crouch Settings")
@export var crouch_height := 1.0     
@export var crouch_head_y := -0.7    
@export var crouch_transition := 8.0  
@export var crouch_fov_shift := -5.0
@export var crouch_bob_amp_mult := 0.5  
@export var crouch_bob_freq_mult := 0.7 

@export_group("Tilt Settings")
@export var tilt_amount := 0.03
@export var mouse_tilt_amount := 0.13
@export var forward_tilt_amount := 0.02
@export var backward_tilt_amount := 0.03
@export var air_tilt_amount := 0.05

@export_group("Smoothness (Lerp)")
@export var pos_smoothing := 7.0
@export var rot_smoothing := 8.0     
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
@export var bob_amp_h := 0.06
@export var bob_amp_v := 0.06

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

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var initial_height : float = COLLISION.shape.height 
@onready var initial_head_y : float = HEAD.position.y      

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if CAMERA and "fov" in CAMERA:
		CAMERA.fov = default_fov

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and not immobile:
		mouse_input_x = event.relative.x 
		HEAD.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var target_rot_x = HEAD.rotation.x - deg_to_rad(event.relative.y * mouse_sensitivity)
		HEAD.rotation.x = clamp(target_rot_x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and not immobile:
		velocity.y = jump_velocity
		target_jump_tilt = jump_tilt_strength 

	var input_dir = Vector2.ZERO if immobile else Input.get_vector("left", "right", "up", "down")
	
	# Приседание
	var is_crouching = Input.is_action_pressed("crouch") or (CEILING_CHECK and CEILING_CHECK.is_colliding())
	process_crouch(delta, is_crouching)
	
	# Расчет скорости
	var is_sprinting = Input.is_action_pressed("sprint") and not is_crouching and (all_direction_sprint or input_dir.y < 0)
	calculate_speed(input_dir, is_crouching, is_sprinting)
	
	var head_basis = HEAD.global_transform.basis
	var direction = (head_basis.x * input_dir.x + head_basis.z * input_dir.y).normalized()
	direction.y = 0 
	
	# --- ЛОГИКА ИНЕРЦИИ (MOMENTUM) ---
	var current_accel = acceleration
	if not is_on_floor() and has_jump_momentum:
		# В воздухе используем air_control для плавного изменения вектора
		current_accel *= air_control
	
	velocity.x = lerp(velocity.x, direction.x * speed, current_accel * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, current_accel * delta)

	last_velocity_y = velocity.y
	move_and_slide()

	if is_on_floor() and not was_on_floor:
		var impact_speed = abs(last_velocity_y)
		if impact_speed > 3.0: 
			var impact_factor = remap(clamp(impact_speed, 3.0, 20.0), 3.0, 20.0, 0.2, 1.0)
			landing_offset -= landing_ebob_amp * impact_factor
			target_jump_tilt = -jump_tilt_strength * impact_factor
			current_shake = shake_strength * impact_factor

	handle_visual_effects(delta, input_dir, is_sprinting, is_crouching)
	was_on_floor = is_on_floor()

func calculate_speed(input_dir, is_crouching, is_sprinting):
	if is_crouching:
		speed = crouch_speed
	elif is_sprinting and input_dir.length() > 0.1:
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

func handle_visual_effects(delta, input_dir, is_sprinting, is_crouching):
	landing_offset = lerp(landing_offset, 0.0, delta * return_speed)
	jump_tilt = lerp(jump_tilt, target_jump_tilt, delta * return_speed * 1.5)
	target_jump_tilt = lerp(target_jump_tilt, 0.0, delta * return_speed)
	current_shake = lerp(current_shake, 0.0, delta * shake_decay)
	
	var current_tilt_z = air_tilt_amount if not is_on_floor() else tilt_amount
	var target_tilt_z = (-input_dir.x * current_tilt_z) - deg_to_rad(mouse_input_x * mouse_tilt_amount)
	HEAD.rotation.z = lerp_angle(HEAD.rotation.z, target_tilt_z, delta * rot_smoothing)
	mouse_input_x = lerp(mouse_input_x, 0.0, delta * 10.0)

	var target_tilt_x = 0.0
	if input_dir.y > 0: target_tilt_x = backward_tilt_amount * input_dir.y
	elif input_dir.y < 0: target_tilt_x = forward_tilt_amount * input_dir.y * (1.5 if is_sprinting else 1.0)
	
	var bob_vec = Vector3.ZERO
	if is_on_floor() and velocity.length() > 0.1:
		var f_mult = crouch_bob_freq_mult if is_crouching else 1.0
		var a_mult = crouch_bob_amp_mult if is_crouching else 1.0
		noise_time += delta * velocity.length() * bob_freq * f_mult
		bob_vec.x = sin(noise_time * 0.5) * bob_amp_h * a_mult
		bob_vec.y = sin(noise_time) * bob_amp_v * a_mult
	else:
		noise_time += delta * idle_noise_speed
		bob_vec = Vector3(cos(noise_time * 0.8) * idle_noise_amp, sin(noise_time * 1.2) * idle_noise_amp, 0)
	
	if current_shake > 0.01:
		bob_vec.x += randf_range(-current_shake, current_shake)
		bob_vec.y += randf_range(-current_shake, current_shake)
	
	var final_target_pos = bob_vec + Vector3(0, landing_offset, 0)
	camera_target.position = camera_target.position.lerp(final_target_pos, delta * pos_smoothing)
	camera_target.rotation.x = lerp_angle(camera_target.rotation.x, target_tilt_x + jump_tilt, delta * rot_smoothing)
	
	if CAMERA:
		CAMERA.global_transform = camera_target.global_transform
		if "fov" in CAMERA:
			var air_fov = clamp(abs(velocity.y) * 0.5, 0.0, 10.0) if not is_on_floor() else 0.0
			var target_fov = default_fov + (fov_shift if is_sprinting else 0.0) + (crouch_fov_shift if is_crouching else 0.0) + air_fov
			CAMERA.fov = lerp(float(CAMERA.fov), target_fov, delta * 5.0)
