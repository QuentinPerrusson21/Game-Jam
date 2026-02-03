extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		# Ici, tu pourras remettre ton code de "mob le plus proche" si tu veux
		var targetenemy = enemies_in_range.front()
		look_at(targetenemy.global_position)

func shoot():
	const Bullet = preload("res://bullet.tscn")
	var new_bullet = Bullet.instantiate()
	
	new_bullet.global_position = %Tir.global_position
	new_bullet.global_rotation = %Tir.global_rotation
	
	# CORRECTION IMPORTANTE SUR LE ADD_CHILD (voir explication plus bas)
	# %Tir.add_child(new_bullet) -> À NE PAS FAIRE
	get_tree().root.add_child(new_bullet) 

func _on_timer_timeout() -> void:
	# C'EST ICI QUE CA SE JOUE :
	# On regarde s'il y a des ennemis dans la zone AVANT de tirer
	var enemies_in_range = get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		shoot()
