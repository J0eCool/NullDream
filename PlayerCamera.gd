class_name PlayerCamera
extends Camera3D

@export var speed: float = 1.0

var player: Node3D

var dist: float
var angle: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	var d = self.position - player.position
	dist = d.length()
	var r = Vector2(d.x, d.z).length()
	angle.x = atan2(d.z, d.x)
	angle.y = atan2(d.y, r)


func camera_input():
	var input = Vector2()
	input.x = Input.get_axis("camera_left", "camera_right")
	input.y = Input.get_axis("camera_down", "camera_up")
	input = input.normalized()
	return input


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float):
	var input = camera_input()
	angle += input*dt
	angle.y = clamp(angle.y, PI/12, PI/2-PI/12)
	var p = Vector2(cos(angle.x), sin(angle.x))
	var r = Vector2(cos(angle.y), sin(angle.y))
	position = player.position + dist * Vector3(p.x*r.x, r.y, p.y*r.x)
	look_at(player.position)
