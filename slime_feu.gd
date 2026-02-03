extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

var health = 2
var is_dying = false 
var is_attacking = false  
var attack_range = 20.0 

func _physics_process(delta):
	if is_dying or is_attacking:
		return

	var dist_to_player = global_position.distance_to(player.global_position)

	if dist_to_player < attack_range:
		start_attack()
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 200.0
		move_and_slide()
		update_animation(direction)

func update_animation(move_input):
	if is_attacking:
		return

	if move_input.length() > 0:
		if move_input.x > 0:
			$AnimatedSprite2D.flip_h = false 
		elif move_input.x < 0:
			$AnimatedSprite2D.flip_h = true  
		
		if $AnimatedSprite2D.animation != "run":
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

func start_attack():
	is_attacking = true
	velocity = Vector2.ZERO 
	
	$AnimatedSprite2D.play("attack")
	
	await $AnimatedSprite2D.animation_finished
	
	await get_tree().create_timer(0.5).timeout
	
	is_attacking = false

func take_damage():
	health -= 1
	if health <= 0 and not is_dying: 
		die()

func die():
	is_dying = true 
	velocity = Vector2.ZERO 
	$CollisionShape2D.set_deferred("disabled", true)
	
	$AnimatedSprite2D.play("hurt") 
	
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(1.0).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	await tween.finished
	
	queue_free()
