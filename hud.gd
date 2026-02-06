extends CanvasLayer 

# On ne garde qu'une seule déclaration par variable
# Utilise get_node_or_null pour éviter que le jeu ne se ferme si un nœud manque
@onready var label_chrono = get_node_or_null("Label2") 
@onready var barre_vie = get_node_or_null("Panel2/TextureProgressBar")

func _ready():
	# On s'assure que la barre est pleine au lancement
	if barre_vie:
		barre_vie.value = 5 # Ou la valeur max de ton perso

func _process(_delta):
	# On met à jour le texte du chrono à chaque image (frame)
	if label_chrono != null:
		label_chrono.text = GameData.formater_temps()
	else:
		# Utile pour débugger si tu as déplacé ton Label dans l'éditeur
		print("Erreur : Le Label2 est introuvable dans le HUD !")

# Cette fonction est appelée par le signal 'hp_changed' du joueur
func actualiser_points_de_vie(nouveau_hp):
	if barre_vie != null:
		barre_vie.value = nouveau_hp
