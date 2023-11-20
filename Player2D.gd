extends CharacterBody2D


@export var speed = 100.0
@export var jump_height = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 100.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# h = 1/2gt^2, v = gt
		# t = sqrt(2h/g)
		# v = g*sqrt(2h/g)
		var jump_vel = sqrt(2*gravity*jump_height)
		velocity.y = -jump_vel
	elif Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.25

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
