extends CharacterBody3D
@onready var stats_component: StatsComponent = $StatsComponent
@onready var enemy_ai_controller: EnemyAIController = $EnemyAIController
@onready var combat_controller: CombatController = $CombatController
@onready var animation_player: AnimationPlayer = $visuals/UAL1_Standard/AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var movement_lock_component: MovementLockComponent = $MovementLockComponent

var is_hurt = false

func _ready():
	stats_component.died.connect(_on_died)
	stats_component.health_changed.connect(_on_health_changed)

func _on_died():

	enemy_ai_controller.set_process(false)

	combat_controller.disable_combat()

	velocity = Vector3.ZERO

	animation_player.play("Death01")
	
	collision_shape_3d.disabled = true
	#animation_tree["parameters/playback"].travel("death")


func _on_health_changed():
	if stats_component.dead:
		return

	if is_hurt:
		return

	enter_hurt_state()


func enter_hurt_state():
	is_hurt = true

	combat_controller.cancel_attack()

	movement_lock_component.lock_movement()

	animation_player.play("Hit_Head")

	await animation_player.animation_finished

	movement_lock_component.unlock_movement()

	is_hurt = false


func _on_animation_finished(anim_name):

	if anim_name == "Death01":
		queue_free()
