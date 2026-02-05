extends Area2D

@export var degats : int = 2
@export var force_recul : float = 400.0

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	var cibles = []
	
	for body in enemies_in_range:
		if body.is_in_group("joueur"):
			continue
			
		if body.is_in_group("ennemi") or body.has_method("take_damage"):
			cibles.append(body)
			
	if cibles.size() > 0:
		var target = cibles.front()
		look_at(target.global_position)
	else:
		rotation = 0 
		
	var angle = rotation_degrees
	angle = wrapf(angle, -180, 180)
	
	if angle > -90 and angle < 90:
		scale.y = 1
	else:
		scale.y = -1

func _on_timer_timeout() -> void:
	attaquer()

func attaquer():
	var enemies_in_range = get_overlapping_bodies()
	
	for body in enemies_in_range:
		
		if body.is_in_group("joueur"):
			continue 

		if body.is_in_group("ennemi") or body.has_method("take_damage"):
			
			# Animation
			if $Pivot/AnimatedSprite2D.sprite_frames.has_animation("attack"):
				$Pivot/AnimatedSprite2D.play("attack")
			
			if body.has_method("take_damage"):
				if body.name == "Boss" or body.is_in_group("boss"):
					body.take_damage() 
				else:
					body.take_damage(degats)
			
			# Recul
			if body.has_method("prendre_recul"):
				body.prendre_recul(global_position, force_recul)
			
			break
