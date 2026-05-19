class_name Weapon
extends Node3D

@export var weapon_data : WeaponData

@onready var hitbox: HitboxComponent = $HitboxComponent

func _ready() -> void:
	#This should be turned on and off by the combat controller. 
	#In theory at least.
	hitbox.monitoring = false
