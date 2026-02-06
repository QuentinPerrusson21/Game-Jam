extends Control

func _ready() -> void:
	# On récupère le temps formaté depuis GameData et on l'affiche
	if has_node("Panel/Label2"):
		$Panel/Label2.text = GameData.formater_temps()
	elif has_node("Label2"):
		$Label2.text = GameData.formater_temps()

func _on_texture_button_pressed() -> void:
	# Retourne à l'écran de titre (Attention à l'orthographe Main menu vs MainMenu)
	get_tree().change_scene_to_file("res://Main menu.tscn")

func _on_texture_button_2_pressed() -> void:
	# Relance la première map du jeu
	get_tree().change_scene_to_file("res://Map 1.tscn")
