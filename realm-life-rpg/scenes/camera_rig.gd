extends Node3D

# Paramètres de configuration
@export var target_to_follow: Node3D # Glisse ton nœud "Joueur" ici dans l'inspecteur
@export var move_speed: float = 10.0
@export var zoom_speed: float = 2.0
@export var min_zoom: float = 5.0
@export var max_zoom: float = 20.0
@export var smoothing: float = 5.0 # Pour un effet fluide

@onready var camera = $Camera3D

# Cette variable va stocker la distance de départ
var _offset: Vector3

func _process(delta):
	handle_zoom(delta)
	if target_to_follow:
		# La position cible n'est plus "le joueur", mais "le joueur + l'écart"
		var target_pos = target_to_follow.global_position + _offset
		
		# On bouge le Rig doucement vers cette nouvelle position
		global_position = global_position.lerp(target_pos, smoothing * delta)

func _ready():
	# Si on a une cible, on calcule la différence de position actuelle
	# entre le Rig et le Joueur.
	if target_to_follow:
		_offset = global_position - target_to_follow.global_position

func handle_zoom(delta):
	# Gestion du zoom avec la molette
	if Input.is_action_just_pressed("ui_zoom_in"):
		camera.size = clamp(camera.size - zoom_speed, min_zoom, max_zoom)
	elif Input.is_action_just_pressed("ui_zoom_out"):
		camera.size = clamp(camera.size + zoom_speed, min_zoom, max_zoom)
