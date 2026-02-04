extends CharacterBody2D

# --- MODIFICATION ICI (DÉBUT) ---
# On supprime la ligne qui cherchait "/root/Game/Player"
var player = null

func _ready():
	# On cherche le joueur dans le groupe "joueur"
	# Cela marche peu importe où tu es (Test de scène ou Jeu complet)
	var liste_joueurs = get_tree().get_nodes_in_group("joueur")
	if liste_joueurs.size() > 0:
		player = liste_joueurs[0]
# --- MODIFICATION ICI (FIN) ---


var health = 50
var is_dying = false 
var is_attacking = false  
var attack_range = 300.0 

# La force de frappe du boss
var damage_amount = 2 

func _physics_process(delta):
	# SÉCURITÉ : Si le joueur n'est pas trouvé (ou mort), on arrête tout pour ne pas crasher
	if player == null:
		return

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
	
	# Optionnel : Petit délai pour le réalisme
	await get_tree().create_timer(0.2).timeout
	
	# On vérifie encore que le joueur est là avant de taper
	if player and player.has_method("take_damage"):
		player.take_damage(damage_amount, global_position) 
	
	await $AnimatedSprite2D.animation_finished
	
	await get_tree().create_timer(0.5).timeout
	
	is_attacking = false

func take_damage():
	health -= 1
	if health <= 0 and not is_dying: 
		die()

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
