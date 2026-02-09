extends Control

@onready var main_button: VBoxContainer = $"Main button"
@onready var options: Panel = $Options

func _ready():
	# On cache les options au lancement
	main_button.visible = true
	options.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# 1. CETTE FONCTION OUVRE LES OPTIONS
func _on_texture_button_3_pressed() -> void:
	print("Clic sur Options détecté !") # Pour voir si ça marche dans la console
	main_button.visible = false
	options.visible = true

# 2. CETTE FONCTION FERME LES OPTIONS
func _on_fermer_pressed() -> void:
	print("Clic sur Fermer détecté !")
	main_button.visible = true
	options.visible = false

# 3. AUTRES BOUTONS
func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Selection personnages.tscn")

func _on_texture_button_4_pressed() -> void:
	get_tree().quit()
