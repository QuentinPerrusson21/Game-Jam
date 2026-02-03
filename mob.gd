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
	
	# Attention: tu avais mis "hurt" ici, j'ai remis "death" qui semble plus logique
	# Si ton animation s'appelle vraiment "hurt", remets "hurt"
	$AnimatedSprite2D.play("hurt")
	
	# On attend la fin de l'animation
	await $AnimatedSprite2D.animation_finished
	
	# On attend un peu que le corps reste au sol (ex: 1 seconde)
	await get_tree().create_timer(1.0).timeout
	
	# --- EFFET DE DISPARITION (FADE OUT) ---
	# 1. On crée un "Tween" (un animateur de code)
	var tween = get_tree().create_tween()
	
	# 2. On dit : "Change la propriété 'modulate:a' (transparence) vers 0.0 (invisible)
	#    en prenant 1.5 seconde"
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	
	# 3. On attend que le tween ait fini son travail
	await tween.finished
	
	# 4. Maintenant qu'il est 100% transparent, on le supprime
	queue_free()
