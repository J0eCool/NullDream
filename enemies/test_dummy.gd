# this may need to be a CharacterController later on, idk
# enemies may need to move eventually; figure that out later *shrug*
extends Area2D


func _ready():
	$Label.visible = false


func get_hit():
	$Label.visible = true
	$HitTimer.start()


func _on_hit_timer_timeout():
	$Label.visible = false
