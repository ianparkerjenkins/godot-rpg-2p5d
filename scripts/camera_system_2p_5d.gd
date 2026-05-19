extends Node3D

@export var player: CharacterBody3D

# FOLLOW
@export var follow_speed := 6.0

# LOOK AHEAD
@export var max_look_ahead_distance := 2.5
@export var max_x_speed = 5.0
@export var look_ahead_speed := 4.0
@export var velocity_threshold := 0.1

# JUMP CAMERA
@export var jump_height_threshold := 1.5
@export var jump_camera_offset := 2.0
@export var vertical_damping := 3.0
@export var z_offset := 3.0
@export var y_offset := 1.5

var current_look_ahead := 0.0
var current_vertical_offset := 0.0

var grounded_y := 0.0


func _ready():
	grounded_y = player.global_position.y


func _process(delta):

	if player == null:
		return

	handle_horizontal_lookahead(delta)
	#handle_vertical_offset(delta)

	var target_position = player.global_position

	target_position.x += current_look_ahead
	target_position.y = y_offset
	target_position.z += z_offset

	global_position = global_position.lerp(
		target_position,
		follow_speed * delta
	)


func handle_horizontal_lookahead(delta):

	var target_look_ahead := 0.0
	var player_x_vel = abs(player.velocity.x)
	if player_x_vel > velocity_threshold:
		var look_ahead_distance = player_x_vel / max_x_speed * max_look_ahead_distance
		target_look_ahead = (
			sign(player.velocity.x)
			* look_ahead_distance
		)

	current_look_ahead = lerp(
		current_look_ahead,
		target_look_ahead,
		look_ahead_speed * delta
	)


#func handle_vertical_offset(delta):
#
	## Update grounded reference point
	#if player.is_on_floor():
		#grounded_y = player.global_position.y
#
	#var height_above_ground = (
		#player.global_position.y - grounded_y
	#)
#
	#var target_vertical_offset := 1.5
#
	## Ignore tiny hops / stair movement
	#if height_above_ground > jump_height_threshold:
#
		#target_vertical_offset = jump_camera_offset
#
	#current_vertical_offset = lerp(
		#current_vertical_offset,
		#target_vertical_offset,
		#vertical_damping * delta
	#)
