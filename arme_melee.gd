extends Node2D

@export var degats : int = 2
@export var force_recul : float = 400.0
@export var cooldown : float = 0.5

var peut_attaquer = true
# C'est ici qu'on stocke la liste des ennemis actuellement dans la zone
var ennemis_a_portee = [] 

func _process(delta):
	# AJOUTE CETTE LIGNE TEMPORAIREMENT :
	print("Ennemis détectés : ", ennemis_a_portee.size())
	
	ennemis_a_portee = ennemis_a_portee.filter(func(e): return is_instance_valid(e))
	
	if ennemis_a_portee.size() == 0:
		return
	# ... suite du code ...

func shoot():
	peut_attaquer = false
	# $AnimationPlayer.play("attack")
	# On attend la fin du cooldown avant de pouvoir retaper
	await get_tree().create_timer(cooldown).timeout
	peut_attaquer = true

# --- PARTIE 1 : LA SURVEILLANCE (DetectionZone) ---
# Ajoute l'ennemi à la liste quand il entre
func _on_detection_zone_body_entered(body):
	if body.has_method("take_damage"):
		ennemis_a_portee.append(body)

# Retire l'ennemi de la liste quand il sort (ou meurt)
func _on_detection_zone_body_exited(body):
	if body in ennemis_a_portee:
		ennemis_a_portee.erase(body)

# --- PARTIE 2 : LES DÉGÂTS (Hitbox de l'épée) ---
# Cette fonction est appelée uniquement quand l'animation active la lame
func _on_hitbox_body_entered(body):
	# On ignore le joueur
	if body.is_in_group("joueur"):
		return
		
	# Si on touche un ennemi valide
	if body.has_method("take_damage"):
		body.take_damage(degats)
		
		# On applique le recul
		if body.has_method("prendre_recul"):
			body.prendre_recul(global_position, force_recul)
