class_name MovementLockComponent
extends Node3D

var lock := false

func lock_movement():
	lock = true

func unlock_movement():
	lock = false

func is_locked() -> bool:
	return lock
