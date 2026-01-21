class_name DamageReceiver
extends Area2D

enum HitType{NORMAL,KNOCKDOWN,POWER}

@export var Parent: Node2D

func hit(damage: int, direction: Vector2, hit_type: HitType) -> void:
	Parent.hit(damage,direction,hit_type)
