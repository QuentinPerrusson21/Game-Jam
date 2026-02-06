extends StaticBody2D

func _ready():
	# Au démarrage du jeu, on choisit l'état par défaut.
	# Ici, je mets "ouvert" pour que le joueur puisse entrer dans la salle.
	ouvrir()

func fermer():
	# 1. VISUEL : On joue l'animation de fermeture
	if $AnimatedSprite2D.sprite_frames.has_animation("close"):
		$AnimatedSprite2D.play("close")
	
	# 2. PHYSIQUE : On active le mur (Le joueur est bloqué)
	# "set_deferred" est OBLIGATOIRE ici pour ne pas faire crasher la physique
	$CollisionShape2D.set_deferred("disabled", false)

func ouvrir():
	# 1. VISUEL : On joue l'animation d'ouverture
	if $AnimatedSprite2D.sprite_frames.has_animation("open"):
		$AnimatedSprite2D.play("open")
	
	# 2. PHYSIQUE : On désactive le mur (Le joueur passe à travers)
	$CollisionShape2D.set_deferred("disabled", true)
