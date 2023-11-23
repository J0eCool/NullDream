extends CharacterBody2D


@export var speed = 100.0
@export var accel_ratio = 3.0
@export var jump_height = 100.0
@export var gravity = 800.0

@export var attack_speed = 1.4


var attack_cooldown = 0.0


func _physics_process(dt):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity*dt

	var attacking = attack_cooldown > 0
	if Input.is_action_just_pressed("jump") and is_on_floor() and not attacking:
		# h = 1/2gt^2, v = gt
		# t = sqrt(2h/g)
		# v = g*sqrt(2h/g)
		var jump_vel = sqrt(2*gravity*jump_height)
		velocity.y = -jump_vel

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.25

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if attacking and is_on_floor():
		direction = 0
	velocity.x = move_toward(velocity.x, direction*speed, dt*accel_ratio*speed)
	if direction and not attacking:
		# need to check sign(scale.y) because of a quirk of how godot handles scale internally
		# see docs for `scale` for details
		scale.x = sign(direction)*sign(scale.y)*abs(scale.x)
		# $AnimatedSprite2D.flip_h = direction < 0

	move_and_slide()

var attack_scene = preload("res://sord.tscn")
var attack_node: Node2D = null
func _process(dt):
	attack_cooldown -= dt
	if attack_cooldown <= 0:
		if attack_node:
			remove_child(attack_node)
			attack_node = null
		if Input.is_action_just_pressed("attack"):
			attack_cooldown = 1 / attack_speed
			attack_node = attack_scene.instantiate()
			add_child(attack_node)
			attack_node.position = Vector2(34, 0)
			attack_node.set_physics_process(true)
#			if not $AnimatedSprite2D.flip_h:
#				attack_node.position = Vector2(34, 0)
#			else:
#				attack_node.position = Vector2(-34, 0)
#				var sprite = attack_node.find_child("Sprite2D") as Sprite2D
#				sprite.flip_h = true
#
