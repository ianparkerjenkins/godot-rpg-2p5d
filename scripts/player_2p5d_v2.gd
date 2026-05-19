class_name PlayerController
extends CharacterBody3D

@onready var visuals: Node3D = $visuals
@onready var animation_player: AnimationPlayer = $visuals/UAL1_Standard/AnimationPlayer
#@onready var attack_hitbox: CollisionShape3D = $AttackHitbox/CollisionShape3D
@onready var weapon_socket = $WeaponSocket

@export var walk_speed := 3.0
@export var run_speed := 5.0
@export var jump_velocity := 4.5
@export var acceleration := 14.0
@export var deceleration := 18.0
@export var turn_speed := 10.0

var movement_locked := false
var facing_direction := 1.0

func _physics_process(delta):

	handle_gravity(delta)
	handle_jump()
	#handle_attack()
	handle_movement(delta)
	handle_animations()

	move_and_slide()


func handle_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta


func handle_jump():
	if movement_locked:
		return

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity


#func handle_attack():
#
	#if Input.is_action_just_pressed("kick") and is_on_floor():
#
		#if animation_player.current_animation != "kick":
#
			#animation_player.play("Sword_Attack")
			#movement_locked = true
#
#
	#if movement_locked and !animation_player.is_playing():
		#movement_locked = false


func handle_movement(delta):

	var input := Input.get_axis("move_left", "move_right")

	if movement_locked:
		input = 0

	var speed = walk_speed

	if Input.is_action_pressed("run"):
		speed = run_speed

	var target_velocity = input * speed

	velocity.x = move_toward(
		velocity.x,
		target_velocity,
		(acceleration if input != 0 else deceleration) * delta
	)

	# Hard lock Z axis for 2.5D
	global_position.z = 0
	velocity.z = 0

	handle_facing_direction(delta, input)


func handle_facing_direction(delta, input):

	if input == 0:
		return

	facing_direction = sign(input)

	var target_rotation = 0

	if facing_direction < 0:
		target_rotation = PI

	visuals.rotation.y = lerp_angle(
		visuals.rotation.y,
		target_rotation,
		turn_speed * delta
	)
	



func handle_animations():

	if movement_locked:
		return

	if not is_on_floor():
		# TODO: Add jump animation.
		play_animation("Jump")
		return

	if abs(velocity.x) > 0.1:

		if Input.is_action_pressed("run"):
			play_animation("Sprint")
		else:
			play_animation("Walk")

	else:
		play_animation("Idle")


func play_animation(anim_name: String):

	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)


@onready var combat_controller = $CombatController

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		combat_controller.primary_attack()

#func enable_attack_hitbox():
	#attack_hitbox.disabled = false
#
#
#func disable_attack_hitbox():
	#attack_hitbox.disabled = true
