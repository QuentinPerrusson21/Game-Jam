extends Control

func _on_texture_button_pressed() -> void:
	# Relance la première map du jeu
	get_tree().change_scene_to_file("res://Main menu.tscn")


func _on_texture_button_2_pressed() -> void:
	# Retourne à l'écran de titre
	get_tree().change_scene_to_file("res://Map 1.tscn")
