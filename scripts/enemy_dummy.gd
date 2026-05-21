extends CharacterBody3D
@onready var enemy_dummy: CharacterBody3D = $"."
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer

@export var max_health := 30

var health := max_health

var IS_LOCKED = false
var IS_DOWN = false


func die():
	queue_free()
	
	
func _physics_process(delta: float) -> void:
	if !animation_player.is_playing() and IS_DOWN:
		animation_player.play("get_up")	
		IS_DOWN = false
	if !animation_player.is_playing() and !IS_DOWN:
		IS_LOCKED = false
	if animation_player.current_animation != "idle" and !IS_LOCKED:
		animation_player.play("idle")
