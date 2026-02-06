extends Node2D

@export_group("Paramètres de Salle")
@export var portes_a_fermer : Array[Node2D] 
@export var liste_mobs_possibles : Array[PackedScene] 
@export var nombre_mobs : int = 3
@export var est_salle_boss : bool = false
var salle_activee = false
var salle_terminee = false

func _ready():
	ouvrir_portes()
	if has_node("DetectionZone"):
		$DetectionZone.body_entered.connect(_on_player_entered)

func _on_player_entered(body):
	if body.is_in_group("joueur") and not salle_activee and not salle_terminee:
		demarrer_salle()

func demarrer_salle():
	salle_activee = true
	fermer_portes()
	
	if est_salle_boss:
		gerer_musique_boss(true)
	
	spawner_mobs()

func fermer_portes():
	for porte in portes_a_fermer:
		if is_instance_valid(porte) and porte.has_method("fermer"):
			porte.fermer()

func ouvrir_portes():
	for porte in portes_a_fermer:
		if is_instance_valid(porte) and porte.has_method("ouvrir"):
			porte.ouvrir()

func spawner_mobs():
	if liste_mobs_possibles.size() == 0: return
	var points_disponibles = $SpawnPoints.get_children()
	if points_disponibles.size() == 0: return

	for i in range(nombre_mobs):
		if points_disponibles.size() == 0: break
			
		var mob_ressource = liste_mobs_possibles.pick_random()
		if mob_ressource == null: continue 

		var nouveau_mob = mob_ressource.instantiate()
		var index_aleatoire = randi() % points_disponibles.size()
		var point_choisi = points_disponibles[index_aleatoire]
		points_disponibles.remove_at(index_aleatoire)
		
		$MobsContainer.call_deferred("add_child", nouveau_mob)
		nouveau_mob.set_deferred("global_position", point_choisi.global_position)
		
		# On connecte le signal de mort
		nouveau_mob.tree_exited.connect(_on_mob_died)

func _on_mob_died():
	if not is_inside_tree():
		return
		
	await get_tree().process_frame
	
	if has_node("MobsContainer"):
		var reste = $MobsContainer.get_child_count()
		if reste == 0 and salle_activee:
			victoire_salle()

func victoire_salle():
	salle_terminee = true
	salle_activee = false
	ouvrir_portes()
	if est_salle_boss:
		gerer_musique_boss(false)

func gerer_musique_boss(activation : bool):
	var tree = get_tree()
	if not tree: return
	
	var musique_donjon = tree.current_scene.find_child("MusiqueDonjon", true, false)
	var musique_boss = find_child("AudioStreamPlayer*", false, false)

	if activation:
		if musique_donjon: musique_donjon.stop()
		if musique_boss: musique_boss.play()
	else:
		if musique_boss: musique_boss.stop()
		if musique_donjon: musique_donjon.play()
