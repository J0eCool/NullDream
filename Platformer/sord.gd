extends Area2D


func _on_area_entered(area):
	# assumes that enemies are Area2Ds, and that attacks only hit enemies due to collision masks
	area.get_hit()
