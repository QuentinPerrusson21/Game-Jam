extends Node2D

# --- REGLAGES DANS L'INSPECTEUR ---
@export var degats : int = 2
@export var force_recul : float = 400.0  # La puissance du coup
@export var cooldown : float = 0.5       # Temps entre deux coups

var peut_attaquer = true

func _ready():
	# On relie la détection de collision
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)

# Le Player appelle cette fonction quand on clique (c'est standardisé)
func shoot():
	if not peut_attaquer:
		return
		
	peut_attaquer = false
	
	# 1. On joue l'animation (ce qui active le CollisionShape !)
	$AnimationPlayer.play("attack")
	
	# 2. On attend la fin du cooldown avant de pouvoir retaper
	await get_tree().create_timer(cooldown).timeout
	peut_attaquer = true

# Cette fonction se déclenche quand le CollisionShape touche quelque chose
func _on_hitbox_body_entered(body):
	# On ne se tape pas soi-même !
	if body.is_in_group("joueur"):
		return
		
	# On tape les ennemis (ceux qui ont une barre de vie)
	if body.has_method("take_damage"):
		body.take_damage(degats)
		print("Paf ! Ennemi touché : ", body.name)
		
	# On repousse les ennemis (si tu as ajouté la fonction dans le Boss)
	if body.has_method("prendre_recul"):
		# On calcule la direction du coup (De l'épée vers l'ennemi)
		body.prendre_recul(global_position, force_recul)
