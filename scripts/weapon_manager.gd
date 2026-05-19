class_name WeaponManager
extends Node

@export var starting_weapon : PackedScene

@onready var weapon_socket : Node3D = $"../visuals/WeaponSocket"

var current_weapon : Weapon

func _ready():
	if starting_weapon:
		print("MANAGER: EQUIPING STARTING WEAPON:", starting_weapon)
		equip(starting_weapon)

func equip(weapon_scene : PackedScene):
	if current_weapon:
		current_weapon.queue_free()

	current_weapon = weapon_scene.instantiate()

	weapon_socket.add_child(current_weapon)

func attack():
	if current_weapon:
		current_weapon.attack()
