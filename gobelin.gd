extends CharacterBody2D

# --- AJOUTS POUR LE SON (Glisse tes fichiers .tres ici dans l'inspecteur) ---
@export var son_pas : AudioStream
@export var son_attaque : AudioStream

# On supprime la ligne qui cherchait "/root/Game/Player"
var player = null

func _ready():
	# 1. On cherche le joueur
	var liste_joueurs = get_tree().get_nodes_in_group("joueur")
	if liste_joueurs.size() > 0:
		player = liste_joueurs[0]
	
	# 2. CONNEXION AUTOMATIQUE POUR LES PAS (Code pur)
	# On dit au code : "Quand l'image change, appelle la fonction _on_frame_changed"
	if not $AnimatedSprite2D.frame_changed.is_connected(_on_frame_changed):
		$AnimatedSprite2D.frame_changed.connect(_on_frame_changed)

var health = 10
var is_dying = false 
var is_attacking = false  
var attack_range = 50.0 

# La force de frappe du boss
var damage_amount = 2 

func _physics_process(delta):
	# Si le joueur est introuvable, on réessaie de le trouver
	if player == null:
		var liste_joueurs = get_tree().get_nodes_in_group("joueur")
		if liste_joueurs.size() > 0:
			player = liste_joueurs[0]
		else:
			$AnimatedSprite2D.play("idle")
			return

	# Si le boss est mort ou attaque, on ne bouge pas
	if is_dying or is_attacking:
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
	
	# --- SON D'ATTAQUE (Code pur) ---
	if son_attaque and has_node("SfxAttaque"):
		$SfxAttaque.stream = son_attaque
		$SfxAttaque.play()
	# --------------------------------
	
	await get_tree().create_timer(0.2).timeout
	
	# On vérifie encore que le joueur est là avant de taper
	if player and player.has_method("take_damage"):
		player.take_damage(damage_amount, global_position) 
	
	await $AnimatedSprite2D.animation_finished
	
	await get_tree().create_timer(0.5).timeout
	
	is_attacking = false

# --- NOUVELLE FONCTION POUR LES PAS (Gérée automatiquement par le _ready) ---
func _on_frame_changed():
	# Si on court
	if $AnimatedSprite2D.animation == "run":
		# REMPLACE 1 et 4 par les images où le pied touche le sol dans TON animation !
		if $AnimatedSprite2D.frame == 1 or $AnimatedSprite2D.frame == 4:
			if son_pas and has_node("SfxPas"):
				$SfxPas.stream = son_pas
				$SfxPas.play()

# --- RESTE DU CODE (Dégâts et Mort) ---
func take_damage(amount = 1):
	health -= amount
	print("Boss touché ! Vie restante : ", health)
	
	modulate = Color(10, 10, 10)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)

	if health <= 0 and not is_dying: 
		die()

func prendre_recul(source, force):
	pass

func die():
	is_dying = true 
	velocity = Vector2.ZERO 
	$CollisionShape2D.set_deferred("disabled", true)
	
	$AnimatedSprite2D.play("hurt") 
	
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(1.0).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	await tween.finished
	
	queue_free()
