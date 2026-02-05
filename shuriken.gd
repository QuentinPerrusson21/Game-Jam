extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var targetenemy = enemies_in_range.front()
		look_at(targetenemy.global_position)
		
		# --- GESTION DE L'INVERSION (FLIP) ---
		# On regarde l'angle actuel de l'arme
		var angle = rotation_degrees
		
		# "normalize" l'angle pour qu'il soit toujours entre -180 et 180
		# (utile si l'arme fait plusieurs tours sur elle-même)
		angle = wrapf(angle, -180, 180)
		
		# Si l'angle est entre 90° et -90° (Côté DROIT) -> Normal
		if angle > -90 and angle < 90:
			scale.y = 1
		# Sinon (Côté GAUCHE) -> On inverse pour que l'arme reste à l'endroit
		else:
			scale.y = -1
			
		# --- GESTION DE LA PROFONDEUR ---
		if targetenemy.global_position.y < global_position.y:
			z_index = -1 
		else:
			z_index = 1

func shoot():
	$WeaponPivot/AnimatedSprite2D.play("shoot")

	const Bullet = preload("res://shuriken_lance.tscn")
	var new_bullet = Bullet.instantiate()
	
	new_bullet.global_position = %Tir.global_position
	new_bullet.global_rotation = %Tir.global_rotation
	
	get_tree().root.add_child(new_bullet) 

func _on_timer_timeout() -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()

func arreter_tir():
	set_physics_process(false)
	$Timer.stop()
