class_name EnemySlot
extends Node2D

var occupanct: BaseEnemy = null

func is_free() -> bool:
	return occupanct == null

func free_the_slot() -> void:
	occupanct = null

func occupy(enemy: BaseEnemy) -> void:
	occupanct = enemy
