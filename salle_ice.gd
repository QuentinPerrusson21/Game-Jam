extends Node2D

# 1. PARAMÈTRES (À régler dans l'inspecteur à droite)
@export var mobs_a_faire_spawn : Array[PackedScene]
@export var nombre_ennemis : int = 3

# 2. LIENS VERS LES PORTES
# Le script va chercher les CollisionShape pour pouvoir les activer/désactiver
@onready var mur_haut = $Portes/PorteHaut/CollisionShape2D
@onready var mur_bas = $Portes/PorteBas/CollisionShape2D

var combat_actif = false
var salle_terminee = false
var mobs_tues = 0

func _ready():
	# Sécurité : On s'assure que les murs sont désactivés (Portes Ouvertes) au début
	ouvrir_portes()

# Cette fonction se lance quand le joueur entre dans la ZoneDetection
func _on_zone_detection_body_entered(body):
	if body.name == "Player" and not combat_actif and not salle_terminee:
		commencer_combat()

func commencer_combat():
	print("Combat commencé ! Je ferme les portes.")
	combat_actif = true
	
	# --- C'EST ICI QUE LA MAGIE OPÈRE ---
	# On dit à Godot : "Rends ces murs solides !"
	# "false" veut dire "Pas désactivé" (donc Actif)
	mur_haut.set_deferred("disabled", false)
	mur_bas.set_deferred("disabled", false)
	# ------------------------------------
	
	spawn_vague()

func spawn_vague():
	var spawn_points = $SpawnPoints.get_children()
	
	if spawn_points.is_empty():
		print("Erreur : Pas de Marker2D dans SpawnPoints !")
		return
		
	for i in range(nombre_ennemis):
		if mobs_a_faire_spawn.is_empty(): return
		
		var mob = mobs_a_faire_spawn.pick_random().instantiate()
		var point = spawn_points.pick_random()
		mob.global_position = point.global_position
		
		# On connecte la mort du mob à notre compteur
		mob.tree_exited.connect(_on_mob_mort)
		
		$MobsContainer.call_deferred("add_child", mob)

func _on_mob_mort():
	mobs_tues += 1
	print("Mob tué : ", mobs_tues, "/", nombre_ennemis)
	
	if mobs_tues >= nombre_ennemis:
		victoire()

func victoire():
	salle_terminee = true
	combat_actif = false
	ouvrir_portes()

func ouvrir_portes():
	# On dit à Godot : "Rends ces murs fantomatiques (Désactivés) !"
	if mur_haut: mur_haut.set_deferred("disabled", true)
	if mur_bas: mur_bas.set_deferred("disabled", true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	# 1. On vérifie que c'est bien le Joueur qui est entré (et pas un autre truc)
	if body.name == "Player":
		
		# 2. On vérifie que le combat n'est pas déjà en cours ou fini
		if not combat_actif and not salle_terminee:
			commencer_combat()
