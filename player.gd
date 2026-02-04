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
# Dans le script du PLAYER
# Dans le script du PLAYER
func take_damage(amount = 1): # Le "= 1" est la valeur par défaut
	if is_dead:
		return
		
	health -= amount # On enlève le montant reçu
	print("Aie ! Vie restante : ", health)
	
	if health <= 0:
		die()

# 4. La logique de mort
func die():
	is_dead = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	
	# --- MODIFICATION ICI ---
	# On cherche l'arme (Vérifie bien que le nom est "Pistolet" ou utilise %Pistolet)
	var arme = get_node_or_null("Gun") 
	
	if arme != null:
		arme.queue_free() # Cette commande supprime l'objet instantanément
	# ------------------------
	
	%Chevalier.play("hurt")
	
	await %Chevalier.animation_finished
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
