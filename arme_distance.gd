extends Area2D

@export var projectile_scene : PackedScene 
@export var cooldown : float = 1.0 
@export var son_de_tir : AudioStream 
@onready var point_de_tir = find_child("PointDeTir") 

func _ready():
	if $Timer:
		$Timer.wait_time = cooldown

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var targetenemy = enemies_in_range.front()
		look_at(targetenemy.global_position)
		
		var angle = wrapf(rotation_degrees, -180, 180)
		if angle > -90 and angle < 90:
			scale.y = 1
		else:
			scale.y = -1
			
		if targetenemy.global_position.y < global_position.y:
			z_index = -1
		else:
			z_index = 1

func shoot():
	if projectile_scene == null:
		return

	# Animation visuelle
	if has_node("WeaponPivot/AnimatedSprite2D"):
		$WeaponPivot/AnimatedSprite2D.play("shoot")

	if son_de_tir != null:
		if has_node("SfxTir"):
			$SfxTir.stream = son_de_tir
			$SfxTir.play()
			
	var new_bullet = projectile_scene.instantiate()
	
	if point_de_tir:
		new_bullet.global_position = point_de_tir.global_position
		new_bullet.global_rotation = point_de_tir.global_rotation
	else:
		new_bullet.global_position = global_position
		new_bullet.global_rotation = global_rotation
	
	get_tree().root.add_child(new_bullet)

func _on_timer_timeout() -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()

func arreter_tir():
	set_physics_process(false)
	if $Timer: $Timer.stop()
