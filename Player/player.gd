extends CharacterBody3D

@export_group("Camera")
@export var camera_pivot: Node3D
@export var camera: Camera3D
@export var spring_arm: SpringArm3D
@export_range(0.0, 1.0) var camera_sensitivity: float = 0.25

@export_group("Movement")
@export var walke_speed: float = 8.0
@export var sprint_speed: float = 12.0
@export var crouch_speed: float = 4.0
@export var acceleration: float = 50.0
@export var rotation_speed: float = 12.0
@export var jump_velocity: float = 6
var move_speed: float = 0.0

@export_group("Body")
@export var player_mesh: Node3D 

var camera_input_direction:Vector2 = Vector2.ZERO
var last_movement_direction: Vector3 = Vector3.BACK


enum VERTICAL_STATE{
	STANDING,
	FALL,
	JUMP,
}
var current_vertical_state: VERTICAL_STATE = VERTICAL_STATE.STANDING

enum MOVMENT_STATE{
	IDLE,
	CROUCHIDLE,
	CROUCHWALK,
	WALK,
	SPRINT,
}

var current_movment_state: MOVMENT_STATE = MOVMENT_STATE.IDLE





func _input(event: InputEvent) -> void:

	
	if event.is_action_pressed("scroll_up"):
		spring_arm.spring_length -= 0.4
		spring_arm.spring_length = clampf(spring_arm.spring_length, 2.0 , 8.0)
	if event.is_action_pressed("scroll_down"):
		spring_arm.spring_length += 0.4
		spring_arm.spring_length = clampf(spring_arm.spring_length, 2.0 , 8.0)


func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED )
	if is_camera_motion:
		camera_input_direction = event.screen_relative * camera_sensitivity
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	camera_movment(delta)
	
	var input_direction: Vector2 = Input.get_vector("move_left","move_right","move_forward","move_backward")

	match current_vertical_state:
		
		VERTICAL_STATE.STANDING:
			if Input.is_action_just_pressed("jump"):
				zwitch_vertical_state(VERTICAL_STATE.JUMP)
			if not is_on_floor():
				zwitch_vertical_state(VERTICAL_STATE.FALL)
		
		VERTICAL_STATE.FALL:
			if is_on_floor():
				zwitch_vertical_state(VERTICAL_STATE.STANDING)
			velocity += get_gravity() * delta * 2.0
			
		VERTICAL_STATE.JUMP:
			if velocity.y < 0: 
				zwitch_vertical_state(VERTICAL_STATE.FALL)
			if velocity.y >= 0:
				velocity += get_gravity() * delta
	
	
	match current_movment_state:
		
		MOVMENT_STATE.IDLE:
			if input_direction != Vector2(0,0) and Input.is_action_just_pressed("sprint"):
				zwitch_movment_state(MOVMENT_STATE.SPRINT)
			elif Input.is_action_pressed("crouch"):
				zwitch_movment_state(MOVMENT_STATE.CROUCHIDLE)
			elif input_direction != Vector2(0,0):
				zwitch_movment_state(MOVMENT_STATE.WALK)
			apply_movement(delta,input_direction)
		
		MOVMENT_STATE.CROUCHIDLE:
			if not Input.is_action_pressed("crouch"):
				zwitch_movment_state(MOVMENT_STATE.IDLE)
			elif input_direction != Vector2(0,0):
				zwitch_movment_state(MOVMENT_STATE.CROUCHWALK)
			apply_movement(delta,input_direction)
		
		MOVMENT_STATE.CROUCHWALK:
			if input_direction == Vector2(0,0):
				zwitch_movment_state(MOVMENT_STATE.CROUCHIDLE)
			elif not Input.is_action_pressed("crouch"):
				zwitch_movment_state(MOVMENT_STATE.IDLE)
			apply_movement(delta,input_direction)
		
		MOVMENT_STATE.WALK:
			if input_direction == Vector2(0,0):
				zwitch_movment_state(MOVMENT_STATE.IDLE)
			elif Input.is_action_pressed("crouch"):
				zwitch_movment_state(MOVMENT_STATE.CROUCHIDLE)
			elif Input.is_action_pressed("sprint"):
				zwitch_movment_state(MOVMENT_STATE.SPRINT)
			apply_movement(delta,input_direction)
		
		MOVMENT_STATE.SPRINT:
			if input_direction == Vector2(0,0):
				zwitch_movment_state(MOVMENT_STATE.IDLE)
			elif not Input.is_action_pressed("sprint"):
				zwitch_movment_state(MOVMENT_STATE.WALK)
			elif Input.is_action_pressed("crouch"):
				zwitch_movment_state(MOVMENT_STATE.CROUCHIDLE)
			apply_movement(delta,input_direction)
	move_and_slide()
	
func camera_movment(delta: float) ->void:
	camera_pivot.rotation.x += camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x,PI / -6.0 , PI / 3.0)
	camera_pivot.rotation.y -= camera_input_direction.x * delta
	camera_input_direction = Vector2.ZERO
	
func zwitch_vertical_state(to_state: VERTICAL_STATE):
	if current_vertical_state == to_state:
		return
	
	current_vertical_state = to_state
	
	match current_vertical_state:
		VERTICAL_STATE.STANDING:
			player_mesh.idle()
			zwitch_movment_state(MOVMENT_STATE.IDLE)
		VERTICAL_STATE.FALL:
			player_mesh.fall()
		VERTICAL_STATE.JUMP:
			velocity.y = jump_velocity
			player_mesh.jump()


func zwitch_movment_state(to_state: MOVMENT_STATE):
	if current_movment_state == to_state:
		return
	
	current_movment_state = to_state
	
	match current_movment_state:
		MOVMENT_STATE.IDLE:
			if current_vertical_state == VERTICAL_STATE.STANDING:
				player_mesh.idle()
		MOVMENT_STATE.CROUCHIDLE:
			if current_vertical_state == VERTICAL_STATE.STANDING:
				player_mesh.crouch_idle()
		MOVMENT_STATE.CROUCHWALK:
			move_speed = crouch_speed
			if current_vertical_state == VERTICAL_STATE.STANDING:
				player_mesh.crouch_walk()
		MOVMENT_STATE.WALK:
			move_speed = walke_speed
			if current_vertical_state == VERTICAL_STATE.STANDING:
				player_mesh.walk()
		MOVMENT_STATE.SPRINT:
			move_speed = sprint_speed
			if current_vertical_state == VERTICAL_STATE.STANDING:
				player_mesh.sprint()


func apply_movement(delta: float,input_direction: Vector2) -> void:
	
	var forward : Vector3 = camera.global_basis.z
	var right: Vector3 = camera.global_basis.x
	var move_direction: Vector3 = forward * input_direction.y + right * input_direction.x
	
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var current_y_velocity = velocity.y
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = current_y_velocity
	
		
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
		var target_angle: float = Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
		player_mesh.global_rotation.y = lerp_angle(player_mesh.rotation.y, target_angle, rotation_speed * delta)


func _on_hp_die() -> void:
	print("die")
