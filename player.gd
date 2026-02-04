extends CharacterBody2D

# 1. On définit la vie du joueur
var health = 5
var is_dead = false # Pour savoir si on bloque les contrôles

func _physics_process(delta):
	# 2. SÉCURITÉ : Si on est mort, on arrête le script ici (plus de mouvement)
	if is_dead:
		return

	var direction = Input.get_vector("move_left","move_right", "move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	
	# Gestion du Flip (Miroir)
	if direction.x > 0:
		%Chevalier.flip_h = false 
	elif direction.x < 0:
		%Chevalier.flip_h = true

	# Gestion des Animations (Marche / Idle)
	if velocity.length() > 0.0:
		%Chevalier.play("run")
	else: 
		%Chevalier.play("idle")

# 3. Cette fonction sera appelée par les ennemis (ex: body.take_damage())
func take_damage():
	# Si on est déjà mort, on ne peut pas mourir deux fois
	if is_dead:
		return
		
	health -= 1
	print("Vie restante : ", health) # Utile pour tester
	
	if health <= 0:
		die()

# 4. La logique de mort
func die():
	is_dead = true
	velocity = Vector2.ZERO # On arrête le personnage net
	
	# On lance l'animation "hurt" comme tu l'as demandé
	%Chevalier.play("hurt")
	
	# On désactive la collision pour ne plus être touché
	$CollisionShape2D.set_deferred("disabled", true)
	
	# On attend la fin de l'animation
	await %Chevalier.animation_finished
	
	# --- FIN DE PARTIE ---
	# Ici, tu peux recharger la scène pour recommencer
	print("Game Over")
	get_tree().reload_current_scene()
