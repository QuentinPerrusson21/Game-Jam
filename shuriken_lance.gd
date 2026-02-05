extends Area2D

var travelled_distance = 0

func _physics_process(delta):
	const speed = 1000
	const range = 1200
	
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	travelled_distance += speed * delta
	if travelled_distance > range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	# --- AJOUT DE LA SÉCURITÉ ICI ---
	# Si l'objet touché fait partie du groupe "joueur", on arrête tout.
	# (Le "return" sert à dire "Stop, ne lis pas la suite")
	if body.is_in_group("joueur"):
		return
	# --------------------------------

	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
