extends Area2D

@export var degats : int = 2
@export var force_recul : float = 400.0

func _physics_process(delta):
	# 1. On cherche les ennemis dans la zone (le gros cercle Area2D)
	var enemies_in_range = get_overlapping_bodies()
	
	# On filtre pour garder les vraies cibles
	var cibles = []
	for body in enemies_in_range:
		if body.is_in_group("ennemi") or body.has_method("take_damage"):
			cibles.append(body)
			
	if cibles.size() > 0:
		# On vise le premier
		var target = cibles.front()
		look_at(target.global_position)
		
		# --- GESTION DU FLIP (Pour que l'épée ne soit pas à l'envers) ---
		var angle = rotation_degrees
		angle = wrapf(angle, -180, 180)
		
		if angle > -90 and angle < 90:
			scale.y = 1
		else:
			scale.y = -1

# Connecte le signal "timeout" du Timer à cette fonction !
func _on_timer_timeout() -> void:
	attaquer()

func attaquer():
	var enemies_in_range = get_overlapping_bodies()
	
	for body in enemies_in_range:
		
		# --- STOP SUICIDE (Ajoute ça ici) ---
		# Si le corps touché est dans le groupe "joueur", on l'ignore !
		if body.is_in_group("joueur"):
			continue  # "Continue" veut dire : passe au suivant, ne lis pas la suite pour lui
		# ------------------------------------

		# Le reste ne change pas...
		if body.is_in_group("ennemi") or body.has_method("take_damage"):
			
			# Animation
			if $Pivot/AnimatedSprite2D.sprite_frames.has_animation("attack"):
				$Pivot/AnimatedSprite2D.play("attack")
			
			# Dégâts
			if body.has_method("take_damage"):
				body.take_damage(degats)
			
			# Recul
			if body.has_method("prendre_recul"):
				body.prendre_recul(global_position, force_recul)
			
			break
