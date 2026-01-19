class_name DamageReceiver
extends Area2D

@export var Parent: Node2D

func hit(damage: int, direction: Vector2) -> void:
	Parent.hit(damage,direction)
