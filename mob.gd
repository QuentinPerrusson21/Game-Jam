extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * 250.0
	move_and_slide()
	
	update_animation(direction)

func update_animation(move_input):
	if move_input.length() > 0:
		if move_input.x > 0:
			$AnimatedSprite2D.flip_h = false 
		elif move_input.x < 0:
			$AnimatedSprite2D.flip_h = true  
	else:
		$AnimatedSprite2D.frame = 0
