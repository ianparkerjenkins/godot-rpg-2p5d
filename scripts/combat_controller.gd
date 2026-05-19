class_name CombatController
extends Node

# TODO: Add weapon system for equip to bind 
# what melee_hitbox and equipped_weapon is
# TODO: Figure out why the first hit_data is always null 
# TODO: Attack animations don't appear to be blending back into idle

#@export var stats : StatsComponent
@export var animation_player : AnimationPlayer
@export var player : PlayerController

#@export var equipped_weapon : WeaponData
@export var weapon_manager : WeaponManager

#@export var melee_hitbox : HitboxComponent

var is_attacking := false
var combo_index := 0

func primary_attack():
	print("ATTACK INPUT")
	if is_attacking:
		print("BLOCKED ATTACK: ALREADY ATTACKING")
		return
	
	var equipped_weapon = weapon_manager.current_weapon

	if equipped_weapon.weapon_data.light_attacks.is_empty():
		return

	var attack = equipped_weapon.weapon_data.light_attacks[combo_index]

	start_attack(equipped_weapon, attack)
	end_attack()

func start_attack(weapon : Weapon, attack : AttackData):
	is_attacking = true
	player.movement_locked = true
	animation_player.play(attack.animation_name)

	var hit = HitData.new()
	hit.damage = attack.damage
	hit.source = get_parent()

	weapon.hitbox.hit_data = hit
	await animation_player.animation_finished
	player.movement_locked = false
	is_attacking = false

func end_attack():
	is_attacking = false

func enable_hitbox():
	weapon_manager.current_weapon.hitbox.monitoring = true

func disable_hitbox():
	weapon_manager.current_weapon.hitbox.monitoring = false
