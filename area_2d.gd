extends Area2D # Ici, c'est correct car le nœud est une Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("joueur"):
		# On ne lance pas le chrono dans le Hub, on attend d'être dans la Map 1
		get_tree().change_scene_to_file("res://Map 1.tscn")
	
