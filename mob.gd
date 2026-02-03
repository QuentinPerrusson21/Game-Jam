extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

var health = 3
var is_dying = false 

func _physics_process(delta):
	if is_dying:
		return

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
