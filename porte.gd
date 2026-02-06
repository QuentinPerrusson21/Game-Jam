extends StaticBody2D

func _ready():
	ouvrir()

func fermer():
	if $AnimatedSprite2D.sprite_frames.has_animation("close"):
		$AnimatedSprite2D.play("close")
	
	$CollisionShape2D.set_deferred("disabled", false)

func ouvrir():
	if $AnimatedSprite2D.sprite_frames.has_animation("open"):
		$AnimatedSprite2D.play("open")
	
	$CollisionShape2D.set_deferred("disabled", true)
