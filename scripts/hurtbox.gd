class_name HurtboxComponent
extends Area3D

signal damaged(amount)

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
	print(hit_data)
	if hit_data != null and hit_data.source != owner:		
		stats.health -= hit_data.damage
		
		print("Took damage: ", hit_data.damage)
		print("Remaining HP: ", stats.health, " on ", self.get_parent())
	
		damaged.emit(hit_data.damage)
