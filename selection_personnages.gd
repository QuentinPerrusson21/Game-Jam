extends Control

func _on_bouton_chevalier_pressed():
	GameData.personnage_choisi_path = "res://Player.tscn"
	
	get_tree().change_scene_to_file("res://Spawn1.tscn")

func _on_bouton_mage_pressed():
	GameData.personnage_choisi_path = "res://Mage.tscn"
	
	get_tree().change_scene_to_file("res://Spawn1.tscn")


func _on_bouton_barbare_pressed():
	GameData.personnage_choisi_path = "res://Barbare.tscn"
	
	get_tree().change_scene_to_file("res://Spawn1.tscn")
