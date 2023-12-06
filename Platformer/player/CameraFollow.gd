extends Camera2D

@export var target: Node2D
@export var tiles: TileMap


func _ready():
	# Automatically set the Limits of the camera to be within the given tilemap
	# Assumes the tilemap is convex
	var size = tiles.tile_set.tile_size
	var used = tiles.get_used_rect()
	limit_left = tiles.position.x + size.x * used.position.x
	limit_right = tiles.position.x + size.x * used.end.x
	limit_top = tiles.position.y + size.y * used.position.y
	limit_bottom = tiles.position.y + size.y * used.end.y


func _physics_process(_dt):
	position = target.position
