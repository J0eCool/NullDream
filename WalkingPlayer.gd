extends CharacterBody3D


@export var move_speed = 3.0
@export var acceleration = 7.5
@export var jump_height = 1.5

@export var look_sensitivity = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D

var mouse_captured: float = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_captured:
		var look = event.relative * 0.001
		camera.rotation.y -= look.x * look_sensitivity
		camera.rotation.x -= look.y * look_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, -PI/2+0.1, PI/2+0.1)
	if event is InputEventMouseButton:
		if not mouse_captured:
			set_mouse_captured(true)

	if Input.is_action_just_pressed("use"):
		set_mouse_captured(not mouse_captured)

	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func set_mouse_captured(val: bool) -> void:
	mouse_captured = val
	if mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(dt: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * dt

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		var jump_vel = sqrt(2*gravity*jump_height)
		velocity.y = jump_vel
	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= 0.25

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector3()
	if mouse_captured:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward = camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	forward.y = 0
	var direction = forward.normalized()
	velocity.x = move_toward(velocity.x, direction.x*move_speed, acceleration*dt)
	velocity.z = move_toward(velocity.z, direction.z*move_speed, acceleration*dt)
		
	move_and_slide()
