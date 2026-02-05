extends CharacterBody2D

var player = null
var health = 3 # J'ai mis 3, c'est mieux que 2 pour tester les armes faibles
var is_dying = false 
var is_attacking = false  
var attack_range = 100.0 

var damage_amount = 2 

# --- NOUVEAU : Variables pour le recul (Knockback) ---
var recul_vector = Vector2.ZERO
var recul_friction = 15.0 # La vitesse à laquelle ils freinent après un coup

func _physics_process(delta):
	# --- CORRECTION : Si le joueur n'est pas là, on le cherche encore ---
	if player == null:
		var liste_joueurs = get_tree().get_nodes_in_group("joueur")
		if liste_joueurs.size() > 0:
			player = liste_joueurs[0]
		else:
			return # Toujours pas de joueur, on attend

	if is_dying: # On retire "is_attacking" ici pour permettre le recul même pendant l'attaque
		return

	# --- NOUVEAU : Gestion Physique du Recul ---
	if recul_vector.length() > 0:
		# On réduit le recul petit à petit (friction)
		recul_vector = recul_vector.lerp(Vector2.ZERO, recul_friction * delta)
		velocity = recul_vector
		move_and_slide()
		return # IMPORTANT : Si on recule, on ne court pas vers le joueur !

	if is_attacking:
		return

	var dist_to_player = global_position.distance_to(player.global_position)

	if dist_to_player < attack_range:
		start_attack()
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 250.0
		move_and_slide()
		update_animation(direction)

func update_animation(move_input):
	if is_attacking:
		return

	if move_input.length() > 0:
		if move_input.x > 0:
			$AnimatedSprite2D.flip_h = false 
		elif move_input.x < 0:
			$AnimatedSprite2D.flip_h = true  
		
		if $AnimatedSprite2D.animation != "run":
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

func start_attack():
	is_attacking = true
	velocity = Vector2.ZERO 
	
	$AnimatedSprite2D.play("attack")
	
	await get_tree().create_timer(0.2).timeout
	
	# Correction ici aussi : ajout d'une vérification de distance pour ne pas taper de loin
	if player and player.has_method("take_damage"):
		# On vérifie si le joueur est toujours proche avant d'infliger les dégâts
		if global_position.distance_to(player.global_position) <= attack_range + 20:
			player.take_damage(damage_amount) 
	
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(0.5).timeout
	is_attacking = false

# --- CORRECTION MAJEURE ICI ---
# On accepte un argument "amount" (montant), avec 1 par défaut
func take_damage(amount = 1):
	health -= amount # On utilise le montant reçu
	
	# Petit effet visuel quand on est touché
	modulate = Color(10, 10, 10) # Flash blanc
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	
	if health <= 0 and not is_dying: 
		die()

# --- NOUVEAU : Fonction appelée par l'épée/marteau ---
func prendre_recul(source_position, force):
	# On calcule la direction opposée au coup
	var direction = (global_position - source_position).normalized()
	recul_vector = direction * force
	# On arrête l'attaque en cours si on se prend un coup violent
	is_attacking = false

func die():
	is_dying = true 
	velocity = Vector2.ZERO 
	$CollisionShape2D.set_deferred("disabled", true)
	
	$AnimatedSprite2D.play("hurt") 
	
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(0.5).timeout # Raccourci un peu
	queue_free()
