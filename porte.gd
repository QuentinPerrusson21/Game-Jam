extends Node2D # On peut utiliser Node2D ou Area2D

# On n'a plus besoin de "scene_suivante"

func fermer():
	visible = true # On voit la porte
	# On active le mur physique (le bouchon)
	$MurPhysique/CollisionShape2D.set_deferred("disabled", false)

func ouvrir():
	visible = false # La porte disparait visuellement
	# On désactive le mur physique (le joueur peut passer)
	$MurPhysique/CollisionShape2D.set_deferred("disabled", true)
