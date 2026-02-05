extends CharacterBody2D

# --- 1. RÉGLAGES (Ajuste ici pour ton Goblin) ---
var health = 3            # Vie plus faible pour un Goblin
var move_speed = 180.0    # Un peu moins rapide que le Boss (250)
var attack_range = 60.0   # Le Goblin doit être très près pour taper (300 c'est trop loin pour lui)
var damage_amount = 1     # Dégâts du Goblin

# --- 2. VARIABLES TECHNIQUES (Ne pas toucher) ---
var player = null
var is_dying = false 
var is_attacking = false  

# --- 3. NOUVEAU : Variables pour le Recul ---
var recul_vector = Vector2.ZERO
var recul_friction = 15.0 

func _ready():
	# On garde TA méthode qui marche pour trouver le joueur
	var liste_joueurs = get_tree().get_nodes_in_group("joueur")
	if liste_joueurs.size() > 0:
		player = liste_joueurs[0]

func _physics_process(delta):
	# 1. TA SÉCURITÉ (Si le joueur est introuvable)
	if player == null:
		var liste_joueurs = get_tree().get_nodes_in_group("joueur")
		if liste_joueurs.size() > 0:
			player = liste_joueurs[0]
		else:
			$AnimatedSprite2D.play("idle")
			return

	if is_dying: 
		return

	# --- 2. NOUVEAU : LE RECUL (S'insère ici) ---
	# Si le Goblin est poussé, il recule au lieu d'avancer
	if recul_vector.length() > 0:
		recul_vector = recul_vector.lerp(Vector2.ZERO, recul_friction * delta)
		velocity = recul_vector
		move_and_slide()
		return # On arrête ici pour qu'il ne puisse pas attaquer en reculant

	# Si on attaque, on ne bouge pas
	if is_attacking:
		return

	# --- 3. TON MOUVEMENT (Inchangé, sauf variables vitesse/range) ---
	var dist_to_player = global_position.distance_to(player.global_position)

	if dist_to_player < attack_range:
		start_attack()
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * move_speed # Utilise la variable move_speed
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
	
	# J'ai gardé TA ligne exacte (avec les 2 arguments) car elle marche chez toi
	if player and player.has_method("take_damage"):
		# Vérification de distance de sécurité pour ne pas taper de trop loin
		if global_position.distance_to(player.global_position) <= attack_range + 20:
			player.take_damage(damage_amount, global_position) 
	
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(0.5).timeout
	is_attacking = false

# --- 4. MODIFIÉ : Fonction pour prendre des dégâts + Flash ---
func take_damage(amount = 1):
	health -= amount
	
	# Effet Flash Blanc
	modulate = Color(10, 10, 10) 
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	
	if health <= 0 and not is_dying: 
		die()

# --- 5. NOUVEAU : Fonction Recul (Appelée par l'épée) ---
func prendre_recul(source_position, force):
	var direction = (global_position - source_position).normalized()
	recul_vector = direction * force
	is_attacking = false # Le coup interrompt l'attaque !

func die():
	is_dying = true 
	velocity = Vector2.ZERO 
	$CollisionShape2D.set_deferred("disabled", true)
	
	$AnimatedSprite2D.play("hurt") 
	
	await $AnimatedSprite2D.animation_finished
	
	# Ton effet de disparition
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	await tween.finished
	
	queue_free()
