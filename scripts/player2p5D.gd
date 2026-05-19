extends CharacterBody3D
#@onready var camera_mount: Node3D = $camera_mount
@onready var visuals: Node3D = $visuals
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $AttackHitbox/CollisionShape3D

@export var WALIKING_SPEED = 3.0
@export var RUNNING_SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var SENS_HORIZONTAL = 0.5
@export var SENS_VERTICAL = 0.5

var IS_RUNNING = false
var IS_LOCKED = false


func enable_attack_hitbox():
	collision_shape_3d.disabled = false

func disable_attack_hitbox():
	collision_shape_3d.disabled = true

func _physics_process(delta: float) -> void:
	if !animation_player.is_playing():
		IS_LOCKED = false 
	
	if Input.is_action_just_pressed("kick") and is_on_floor():
		if animation_player.current_animation != "kick":
			animation_player.play("kick")
			IS_LOCKED = true
			
		
	var speed = 0 
	if Input.is_action_pressed("run"):
		speed = RUNNING_SPEED
		IS_RUNNING = true
	else:
		speed = WALIKING_SPEED
		IS_RUNNING = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !IS_LOCKED:
			if !IS_RUNNING:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
			else:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			
			visuals.look_at(position + Vector3(direction.x, 0 , 0))
		
		velocity.x = direction.x * speed
		# LOCK Z DIRECT FOR 2.5D
		velocity.z = 0 #  direction.z * speed
	else:
		if !IS_LOCKED:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		# LOCK Z DIRECT FOR 2.5D
		#velocity.z = move_toward(velocity.z, 0, speed)

	if !IS_LOCKED:
		move_and_slide()
		
		
#func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


#func _input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(-event.relative.x) * SENS_HORIZONTAL)
		#visuals.rotate_y(deg_to_rad(event.relative.x) * SENS_HORIZONTAL)
		#camera_mount.rotate_x(deg_to_rad(-event.relative.y) * SENS_VERTICAL)
			
