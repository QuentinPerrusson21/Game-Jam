extends Area2D

# --- CONFIGURATION DANS L'INSPECTEUR ---
# Ici, tu pourras glisser ta scène de balle (Fleche, Balle, BouleDeFeu...)
@export var projectile_scene : PackedScene 

# Ici, tu pourras régler la vitesse de tir pour chaque arme
@export var cooldown : float = 1.0 

# Pour éviter les problèmes de nom (%Tir vs %TirArc), on définit le nom du point de spawn
@onready var point_de_tir = find_child("PointDeTir") # Renomme tes Marker2D en "PointDeTir" !

func _ready():
	# On règle le timer automatiquement selon le cooldown choisi
	if $Timer:
		$Timer.wait_time = cooldown

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var targetenemy = enemies_in_range.front()
		
		# On vise l'ennemi
		look_at(targetenemy.global_position)
		
		# --- GESTION DU FLIP ET Z-INDEX ---
		var angle = wrapf(rotation_degrees, -180, 180)
		
		if angle > -90 and angle < 90:
			scale.y = 1
		else:
			scale.y = -1
			
		if targetenemy.global_position.y < global_position.y:
			z_index = -1
		else:
			z_index = 1

func shoot():
	# SÉCURITÉ : Si on a oublié de mettre une balle dans l'inspecteur
	if projectile_scene == null:
		print("ERREUR : Aucune balle assignée à cette arme dans l'inspecteur !")
		return

	# Si tu as une animation de tir
	if has_node("WeaponPivot/AnimatedSprite2D"):
		$WeaponPivot/AnimatedSprite2D.play("shoot")

	# --- CRÉATION DE LA BALLE ---
	# On utilise la variable "projectile_scene" au lieu du preload fixe
	var new_bullet = projectile_scene.instantiate()
	
	if point_de_tir:
		new_bullet.global_position = point_de_tir.global_position
		new_bullet.global_rotation = point_de_tir.global_rotation
	else:
		# Si on ne trouve pas le point de tir, on tire depuis le centre de l'arme
		new_bullet.global_position = global_position
		new_bullet.global_rotation = global_rotation
	
	get_tree().root.add_child(new_bullet)

func _on_timer_timeout() -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()

func arreter_tir():
	set_physics_process(false)
	if $Timer: $Timer.stop()
