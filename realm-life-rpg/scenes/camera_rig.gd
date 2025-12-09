extends Node3D

# Paramètres de configuration
@export var target_to_follow: Node3D # Glisse ton nœud "Joueur" ici dans l'inspecteur
@export var move_speed: float = 10.0
@export var zoom_speed: float = 2.0
@export var min_zoom: float = 5.0
@export var max_zoom: float = 20.0
@export var smoothing: float = 5.0 # Pour un effet fluide

@onready var camera = $Camera3D

func _process(delta):
	handle_movement(delta)
	handle_zoom(delta)

func handle_movement(delta):
	# Si on a une cible (le joueur), on la suit
	if target_to_follow:
		var target_pos = target_to_follow.global_position
		# Interpolation pour fluidifier le mouvement (Lerp)
		global_position = global_position.lerp(target_pos, delta * smoothing)
	else:
		# Sinon, mouvement manuel (ZQSD / WASD) pour tester
		var input_dir = Input.get_vector("left", "right", "up", "down")
		# On transforme l'input pour qu'il corresponde à la rotation de la caméra (45 degrés)
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		global_position += direction * move_speed * delta

func handle_zoom(delta):
	# Gestion du zoom avec la molette
	if Input.is_action_just_pressed("ui_zoom_in"):
		camera.size = clamp(camera.size - zoom_speed, min_zoom, max_zoom)
	elif Input.is_action_just_pressed("ui_zoom_out"):
		camera.size = clamp(camera.size + zoom_speed, min_zoom, max_zoom)
