extends Control

func _on_bouton_chevalier_pressed():
	# On enregistre le chemin du Chevalier dans la mémoire globale
	GameData.personnage_choisi_path = "res://Player.tscn"

func _on_bouton_mage_pressed():
	GameData.personnage_choisi_path = "res://Mage.tscn"

func _on_bouton_barbare_pressed():
	GameData.personnage_choisi_path = "res://Barbare.tscn"

func _on_bouton_start_pressed():
	# On lance le jeu (qui va lire la mémoire GameData)
	get_tree().change_scene_to_file("res://salle_ice.tscn")
