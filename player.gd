extends CharacterBody2D

# 1. On définit la vie du joueur
var health = 5
var is_dead = false 

# --- NOUVEAU : Variables pour le recul ---
var knockback_vector = Vector2.ZERO
var knockback_friction = 2000.0 # La vitesse à laquelle on freine après le choc

func _physics_process(delta):
	if is_dead:
		return

	# --- GESTION DU RECUL ---
	# Si on a été poussé, on réduit la force petit à petit (frottement)
	if knockback_vector != Vector2.ZERO:
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, knockback_friction * delta)

	# --- GESTION DU MOUVEMENT ---
	var direction = Input.get_vector("move_left","move_right", "move_up","move_down")
	
	# On additionne le mouvement du joueur (clavier) + la force du coup reçu
	velocity = (direction * 600) + knockback_vector
	
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

# 3. Fonction modifiée pour accepter la "source_position" (d'où vient le coup)
func take_damage(amount = 1, source_position = Vector2.ZERO): 
	if is_dead:
		return
		
	health -= amount 
	
	# --- CALCUL DU RECUL ---
	if source_position != Vector2.ZERO:
		# On calcule la direction opposée à l'attaquant
		var direction_recul = (global_position - source_position).normalized()
		# On applique une impulsion brutale (ici 1000 de force)
		knockback_vector = direction_recul * 800.0
		
		# Petit bonus : un flash rouge pour bien sentir le coup
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.1)
		tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	# -----------------------
	
	if health <= 0:
		die()

# 4. La logique de mort
func die():
	is_dead = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	
	var arme = get_node_or_null("Gun") 
	if arme != null:
		arme.queue_free() 
	
	%Chevalier.play("hurt")
	
	await %Chevalier.animation_finished
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
