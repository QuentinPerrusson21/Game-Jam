extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var targetenemy = enemies_in_range.front()
		look_at(targetenemy.global_position)
	
		var angle = rotation_degrees

		angle = wrapf(angle, -180, 180)
		
		if angle > -90 and angle < 90:
			scale.y = 1
		else:
			scale.y = -1
		if targetenemy.global_position.y < global_position.y:
			z_index = -1 
		else:
			z_index = 1

func shoot():
	$WeaponPivot/AnimatedSprite2D.play("shoot")

	const Bullet = preload("res://flecheArc.tscn")
	var new_bullet = Bullet.instantiate()
	
	new_bullet.global_position = %TirArc.global_position
	new_bullet.global_rotation = %TirArc.global_rotation
	
	get_tree().root.add_child(new_bullet) 

func _on_timer_timeout() -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()

func arreter_tir():
	set_physics_process(false)
	$Timer.stop()
