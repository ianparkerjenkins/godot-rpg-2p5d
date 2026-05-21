class_name HurtboxComponent
extends Area3D

@export var stats : StatsComponent

func _ready():
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
	print(self)
	print("Monitoring:", monitoring)
	print("Monitorable:", monitorable)
	print("Layer:", collision_layer)
	print("Mask:", collision_mask)
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

func take_hit(hit_data : HitData):
	if hit_data != null and hit_data.source != owner:
		print("hit registered: ", hit_data.source, hit_data.damage)
		stats.take_damage(hit_data.damage)
