class_name EnemyAIController
extends Node
@onready var animation_player: AnimationPlayer = $"../visuals/UAL1_Standard/AnimationPlayer"
@onready var combat_controller: CombatController = $"../CombatController"

@export var attack_interval := 2.0


func _ready():
	attack_loop()

func attack_loop() -> void:
	if animation_player.current_animation != "Idle":
		animation_player.play("Idle")
	
	while true:
		combat_controller.primary_attack()

		await get_tree().create_timer(attack_interval).timeout
