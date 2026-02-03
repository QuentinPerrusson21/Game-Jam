extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var targetenemy = enemies_in_range.front()
		look_at(targetenemy.global_position)
		
func shoot():
	const Bullet = preload("res://bullet.tscn")
	var new_bullet = Bullet.instantiate()
	new_bullet.global_position = %Tir.global_position
	new_bullet.global_rotation = %Tir.global_rotation
	%Tir.add_child(new_bullet)


func _on_timer_timeout() -> void:
	shoot()
