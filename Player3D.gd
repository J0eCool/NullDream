extends CharacterBody3D

@export var speed: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move_input() -> Vector2:
	var input = Vector2()
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_down", "move_up")
	if (input.length() > 1.0):
		input = input.normalized()
	return input


func _physics_process(_delta):
	var input = move_input()

	var camera = get_viewport().get_camera_3d()
	var delta: Vector3 = self.get_position() - camera.get_position()
	delta.y = 0
	var up: Vector3 = delta.normalized()
	var right: Vector3 = up.rotated(Vector3.UP, -PI/2)
	
	velocity = (input.x*right + input.y*up) * speed
	move_and_slide()
