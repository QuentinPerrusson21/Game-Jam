extends Node

var personnage_choisi_path : String = "res://Player.tscn"

var temps_ecoule : float = 0.0
var chrono_actif : bool = false

func _process(delta):
	if chrono_actif:
		temps_ecoule += delta

func formater_temps() -> String:
	var minutes = int(temps_ecoule / 60)
	var secondes = int(temps_ecoule) % 60
	var millisecondes = int((temps_ecoule - int(temps_ecoule)) * 100)
	return "%02d:%02d:%02d" % [minutes, secondes, millisecondes]
