class_name StatsComponent
extends Node

# TODO: Pass entity data for needed values

signal died
signal health_changed

@export var max_health := 100

var current_health := 100
var dead := false

func _ready():
	current_health = max_health

func take_damage(amount : int):

	if dead:
		return

	current_health -= amount

	health_changed.emit()

	if current_health <= 0:
		die()

func die():

	if dead:
		return

	dead = true
	died.emit()
