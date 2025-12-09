extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# On récupère l'objet CameraRig pour connaître son angle, 
# ou on définit l'angle manuellement si la caméra ne bouge pas.
@export var camera_angle_y: float = 45.0 

# Pour lisser la rotation du personnage
var rotation_speed = 10.0

func _physics_process(delta: float) -> void:
	# 1. Gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Mouvement ISOMÉTRIQUE
	var input_dir := Input.get_vector("left", "right", "up", "down")
	
	# On crée un vecteur 3D à partir de l'input 2D
	var direction_raw = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	# MAGIE ICI : On fait tourner ce vecteur de 45 degrés (l'angle de ta caméra)
	# On utilise deg_to_rad car la rotation se fait en radians
	var direction = direction_raw.rotated(Vector3.UP, deg_to_rad(camera_angle_y))

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# 4. Rotation du personnage (pour qu'il regarde où il va)
		# On calcule l'angle cible
		var target_rotation = atan2(velocity.x, velocity.z)
		# On lisse la rotation actuelle vers la cible
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
