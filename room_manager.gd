extends Node2D

# --- CONFIGURATION ---
@export_group("Paramètres de Salle")
# Glisse ici les portes physiques qui entourent CETTE salle spécifique
@export var portes_a_fermer : Array[Node2D] 

# --- CHANGEMENT ICI : On utilise une liste (Array) ---
@export var liste_mobs_possibles : Array[PackedScene] 

# Nombre total de monstres qui vont apparaître (choisis au hasard dans la liste)
@export var nombre_mobs : int = 3
@export var est_salle_boss : bool = false

var salle_activee = false
var salle_terminee = false

func _ready():
	# On s'assure que les portes sont ouvertes au début
	ouvrir_portes()
	# On connecte la zone de détection
	if has_node("DetectionZone"):
		$DetectionZone.body_entered.connect(_on_player_entered)
	else:
		push_error("ERREUR : Il manque le noeud DetectionZone (Area2D) dans le RoomManager")

func _on_player_entered(body):
	if body.is_in_group("joueur") and not salle_activee and not salle_terminee:
		print("Joueur détecté ! Démarrage de la salle : ", self.name)
		demarrer_salle()

func demarrer_salle():
	salle_activee = true
	fermer_portes()
	spawner_mobs()

func fermer_portes():
	for porte in portes_a_fermer:
		if porte and porte.has_method("fermer"):
			porte.fermer()
	print("Portes fermées.")

func ouvrir_portes():
	for porte in portes_a_fermer:
		if porte and porte.has_method("ouvrir"):
			porte.ouvrir()
	print("Portes ouvertes.")

func spawner_mobs():
	if liste_mobs_possibles.size() == 0:
		return

	# 1. On récupère TOUS les points disponibles
	var points_disponibles = $SpawnPoints.get_children()
	
	if points_disponibles.size() == 0:
		return

	print("Apparition de ", nombre_mobs, " monstres...")

	for i in range(nombre_mobs):
		# Sécurité : si on a plus de monstres que de points, on s'arrête 
		# ou on réutilise (mais ici on veut éviter le stack)
		if points_disponibles.size() == 0:
			print("Plus de points de spawn libres !")
			break
			
		var mob_aleatoire = liste_mobs_possibles.pick_random()
		var nouveau_mob = mob_aleatoire.instantiate()
		
		# 2. On choisit un point et on le RETIRE de la liste pour ce tour
		var index_aleatoire = randi() % points_disponibles.size()
		var point_choisi = points_disponibles[index_aleatoire]
		points_disponibles.remove_at(index_aleatoire) # Ce point n'est plus "disponible"
		
		# 3. Apparition différée (pour éviter l'erreur de tout à l'heure)
		$MobsContainer.call_deferred("add_child", nouveau_mob)
		nouveau_mob.set_deferred("global_position", point_choisi.global_position)
		
		nouveau_mob.tree_exited.connect(_on_mob_died)
func _on_mob_died():
	await get_tree().process_frame
	var reste = $MobsContainer.get_child_count()
	print("Monstres restants : ", reste)
	
	if reste == 0 and salle_activee:
		victoire_salle()

func victoire_salle():
	print("Félicitations ! Salle nettoyée.")
	salle_terminee = true
	salle_activee = false
	ouvrir_portes()
