extends Node2D 

func _ready():
	await get_tree().process_frame
	
	if GameData.personnage_choisi_path != "":
		var perso_ressource = load(GameData.personnage_choisi_path)
		if perso_ressource:
			var joueur = perso_ressource.instantiate()
			
			# On l'ajoute à la scène
			add_child(joueur)
			
			# On le place au Marker
			if has_node("%SpawnHub"):
				joueur.global_position = %SpawnHub.global_position
			
			# On s'assure qu'il est bien dans le groupe pour être détecté
			joueur.add_to_group("joueur")

# C'est cette fonction qui est appelée quand tu touches l'Area2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	# On vérifie si c'est bien le joueur qui entre
	if body.is_in_group("joueur"):
		print("TP vers Map 1 !") # Pour vérifier dans la console
		get_tree().change_scene_to_file("res://Map 1.tscn")
