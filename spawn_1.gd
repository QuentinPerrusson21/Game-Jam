extends Control

# On récupère les deux menus
@onready var main_button: VBoxContainer = $"Main button"
@onready var options: Panel = $Options

func _ready():
	# Au lancement, on cache les options et on montre le menu principal
	main_button.visible = true
	options.visible = false
	# On s'assure que la souris est bien visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Appelé quand tu cliques sur OPTIONS (TextureButton3)
func _on_texture_button_3_pressed() -> void:
	# On cache les boutons principaux et on affiche le panneau d'options
	main_button.visible = false
	options.visible = true

# Appelé quand tu cliques sur le bouton FERMER dans les options
func _on_fermer_pressed() -> void:
	# On fait l'inverse : on revient au menu principal
	main_button.visible = true
	options.visible = false

# --- AUTRES BOUTONS ---

func _on_texture_button_pressed() -> void: # Start Game
	get_tree().change_scene_to_file("res://Selection personnages.tscn")

func _on_texture_button_4_pressed() -> void: # Quit Game
	get_tree().quit()
