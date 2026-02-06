extends Node2D

func _ready():
	if GameData.personnage_choisi_path != "":
		var perso_ressource = load(GameData.personnage_choisi_path)
		
		var joueur = perso_ressource.instantiate()
		
		if has_node("SpawnPoint"):
			joueur.global_position = $SpawnPoint.global_position
		
		add_child(joueur)
		
		# --- CONNEXION AU HUD ---
		# On vérifie si le HUD existe dans la scène
		if has_node("HUD"):
			# On connecte le signal 'hp_changed' du joueur à la fonction du HUD
			# Assure-toi d'avoir créé le signal dans ton script Player !
			joueur.hp_changed.connect($HUD.actualiser_points_de_vie)
		# -------------------------
		
		GameData.temps_ecoule = 0.0  
		GameData.chrono_actif = true
