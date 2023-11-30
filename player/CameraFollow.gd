extends Camera2D

@export var target: Node2D


func _physics_process(_dt):
	# hey what if we had the camera kept within the bounds of a target tilemap
	position = target.position
