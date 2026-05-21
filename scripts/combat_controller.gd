class_name CombatController
extends Node

# TODO: Add a new weapon and equip cycle to it to hit enemy

@export var animation_player : AnimationPlayer
@export var movement_locker : MovementLockComponent
@export var weapon_manager : WeaponManager

var is_attacking := false
var combo_index := 0
var current_attack : AttackData
var attack_timer := 0
var combat_enabled := true 

func disable_combat():
	combat_enabled = false

func cancel_attack():
	is_attacking = false
	weapon_manager.current_weapon.hitbox.disable_hitbox()

func primary_attack():
	if is_attacking or !combat_enabled:
		return
	
	var equipped_weapon = weapon_manager.current_weapon
	if equipped_weapon.weapon_data.light_attacks.is_empty():
		return

	var attack = equipped_weapon.weapon_data.light_attacks[combo_index]
	start_attack(equipped_weapon, attack)


func start_attack(weapon : Weapon, attack : AttackData):

	movement_locker.lock_movement()

	animation_player.play(attack.animation_name)

	is_attacking = true
	current_attack = attack
	attack_timer = 0

	var hit = HitData.new()
	hit.damage = attack.damage
	hit.source = get_parent()

	weapon.hitbox.hit_data = hit


func _physics_process(delta):

	if !is_attacking or !combat_enabled:
		return

	attack_timer += 1

	# Startup finished
	if attack_timer == current_attack.startup_frames:
		weapon_manager.current_weapon.hitbox.enable_hitbox()

	# Active finished
	if attack_timer == current_attack.startup_frames + current_attack.active_frames:
		weapon_manager.current_weapon.hitbox.disable_hitbox()

	# Attack finished
	if attack_timer >= (
		current_attack.startup_frames
		+ current_attack.active_frames
		+ current_attack.recovery_frames
	):
	
		is_attacking = false

		weapon_manager.current_weapon.hitbox.disable_hitbox()

		movement_locker.unlock_movement()
