extends Node2D

func _ready():
	if GameData.personnage_choisi_path != "":
		var perso_ressource = load(GameData.personnage_choisi_path)
		
		var joueur = perso_ressource.instantiate()
		
		if has_node("SpawnPoint"):
			joueur.global_position = $SpawnPoint.global_position
		
		add_child(joueur)
		
		GameData.temps_ecoule = 0.0  
		GameData.chrono_actif = true 
