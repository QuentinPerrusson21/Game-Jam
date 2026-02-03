extends CharacterBody2D

func _physics_process(delta):
	var direction = Input.get_vector("move_left","move_right", "move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	
	if direction.x > 0:
		%Chevalier.flip_h = false 
	elif direction.x < 0:
		%Chevalier.flip_h = true

	# 3. Animations
	if velocity.length() > 0.0:
		%Chevalier.play("run")
	else: 
		%Chevalier.play("idle")
