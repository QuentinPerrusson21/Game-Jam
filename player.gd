extends CharacterBody2D

# --- VARIABLES SONS (Glisse tes .tres ici dans l'inspecteur) ---
@export var son_pas : AudioStream
@export var son_douleur : AudioStream

# --- VARIABLES DU JOUEUR ---
var health = 5
var is_dead = false 

# Variables pour le recul
var knockback_vector = Vector2.ZERO
var knockback_friction = 2000.0

# --- VARIABLES POUR LES ARMES ---
@onready var porte_armes = $PorteArmes 
var index_arme_actuelle = 0

func _ready():
	add_to_group("joueur")
	initialiser_armes()
	
	# --- CONNEXION AUTOMATIQUE DES PAS ---
	# On dit : "Quand l'image du Chevalier change, lance la fonction _on_frame_changed"
	if %Chevalier:
		%Chevalier.frame_changed.connect(_on_frame_changed)

# C'EST ICI QU'ON ECOUTE LA TOUCHE TAB
func _input(event):
	if event.is_action_pressed("changer_arme"):
		changer_arme_suivante()

func _physics_process(delta):
	if is_dead: return

	# Gestion du recul
	if knockback_vector != Vector2.ZERO:
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, knockback_friction * delta)

	# Mouvement
	var direction = Input.get_vector("move_left","move_right", "move_up","move_down")
	velocity = (direction * 600) + knockback_vector
	move_and_slide()
	
	# Animation & Flip
	if direction.x > 0:
		%Chevalier.flip_h = false 
	elif direction.x < 0:
		%Chevalier.flip_h = true

	if velocity.length() > 0.0:
		# IMPORTANT : Si l'anim n'est pas déjà "run", on la lance
		if %Chevalier.animation != "run":
			%Chevalier.play("run")
	else: 
		%Chevalier.play("idle")

# --- GESTION DES SONS DE PAS ---
func _on_frame_changed():
	# Si le joueur court
	if %Chevalier.animation == "run":
		# --- REGLE ICI LES NUMEROS D'IMAGES ---
		# Regarde dans tes SpriteFrames à quel moment le pied touche le sol.
		# Remplace 1 et 4 par TES chiffres (0, 1, 2, 3...)
		if %Chevalier.frame == 1 or %Chevalier.frame == 4:
			if son_pas and has_node("SfxPas"):
				$SfxPas.stream = son_pas
				$SfxPas.play()

# --- GESTION DES ARMES ---

func initialiser_armes():
	if not porte_armes or porte_armes.get_child_count() == 0:
		return
	var armes = porte_armes.get_children()
	for i in range(armes.size()):
		if i == 0: activer_arme(armes[i])
		else: desactiver_arme(armes[i])

func changer_arme_suivante():
	var armes = porte_armes.get_children()
	if armes.size() == 0: return
	desactiver_arme(armes[index_arme_actuelle])
	index_arme_actuelle += 1
	if index_arme_actuelle >= armes.size():
		index_arme_actuelle = 0 
	activer_arme(armes[index_arme_actuelle])

func activer_arme(arme):
	arme.visible = true
	arme.process_mode = Node.PROCESS_MODE_INHERIT

func desactiver_arme(arme):
	arme.visible = false
	arme.process_mode = Node.PROCESS_MODE_DISABLED

# --- GESTION DES DEGATS ---

func take_damage(amount = 1, source_position = Vector2.ZERO): 
	if is_dead: return
		
	health -= amount 
	
	# --- SON DE DOULEUR ---
	if son_douleur and has_node("SfxDouleur"):
		$SfxDouleur.stream = son_douleur
		$SfxDouleur.play()
	# ----------------------
	
	if source_position != Vector2.ZERO:
		var direction_recul = (global_position - source_position).normalized()
		knockback_vector = direction_recul * 800.0
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.1)
		tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	if porte_armes: porte_armes.queue_free() 
	%Chevalier.play("hurt")
	await %Chevalier.animation_finished
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
