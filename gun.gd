extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var targetenemy = enemies_in_range.front()
		look_at(targetenemy.global_position)

func shoot():
	# --- AJOUT ICI ---
	# On lance l'animation de tir
	# Vérifie que ton noeud s'appelle bien "AnimatedSprite2D"
	$WeaponPivot/AnimatedSprite2D.play("shoot")
	# -----------------

	const Bullet = preload("res://bullet.tscn")
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
