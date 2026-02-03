extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_Caractere_selection_pressed() -> void:
	get_tree().change_scene_to_file("res://survivorsGame.tscn")

func _on_achievement_pressed() -> void:
	print("achievments")
	pass


func _on_options_pressed() -> void:
	print("options")
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
