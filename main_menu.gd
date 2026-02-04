extends Control

@onready var main_button: VBoxContainer = $"Main button"
@onready var options: Panel = $"Options"


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func _ready(): 
	main_button.visible = true
	options.visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://salle_ice.tscn")

func _on_option_pressed() -> void:
	main_button.visible = false
	options.visible = true

	
func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_fermer_option_pressed() -> void:
	main_button.visible = true
	options.visible = false


func _on_achievements_pressed() -> void:
	get_tree().change_scene_to_file("res://hud.tscn")
