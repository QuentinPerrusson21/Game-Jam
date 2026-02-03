extends CharacterBody2D


@onready var player = get_node("/root/Game/Player")
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 250.0
	move_and_slide()

func update_animations(direction):
	if direction == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
