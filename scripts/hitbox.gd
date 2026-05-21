class_name HitboxComponent
extends Area3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var hit_data : HitData

var hit_targets := []

func enable_hitbox():
	monitoring = true
	hit_targets.clear()

func disable_hitbox():
	monitoring = false
	hit_targets.clear()

func _on_area_entered(area):

	if !monitoring:
		return

	if area in hit_targets:
		return

	hit_targets.append(area)

	if area is HurtboxComponent:
		area.take_hit(hit_data)

func _ready():
	collision_shape_3d.disabled = false
	area_entered.connect(_on_area_entered)
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
	print(self)
	print("Monitoring:", monitoring)
	print("Monitorable:", monitorable)
	print("Layer:", collision_layer)
	print("Mask:", collision_mask)
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

#func _on_area_entered(area):
	#if area is HurtboxComponent:
		#area.take_hit(hit_data)
