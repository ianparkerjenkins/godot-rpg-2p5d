class_name CombatController
extends Node

# TODO: Attack animations don't appear to be blending back into idle
# TODO: Add a new weapon and equip cycle to it to hit enemy
# TODO: Characters die when health <= 0 from StatsComponent
# TODO: Make decision on how to handle jumping attacks

@export var animation_player : AnimationPlayer
@export var player : PlayerController
@export var weapon_manager : WeaponManager

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

# Hook these methods up to the 
# correct frames of the corresponding animations. 

func enable_hitbox():
	weapon_manager.current_weapon.hitbox.monitoring = true

func disable_hitbox():
	weapon_manager.current_weapon.hitbox.monitoring = false
