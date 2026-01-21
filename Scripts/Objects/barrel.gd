extends StaticBody2D

@export var knockback_force := 100.

enum States {Idle, Destroyed}
var current_state := States.Idle
const GRAVITY := 600

var height := 0.
var height_speed := 0.
var velocity := Vector2.ZERO

func _process(delta: float) -> void:
	position += velocity * delta
	$Sprite2D.position.y =  -height
	handle_air_time(delta)

func hit(_damage: int, direction: Vector2, _hit_type:DamageReceiver.HitType) -> void:
	if current_state == States.Idle:
		current_state = States.Destroyed
		$Sprite2D.frame = 1
		height_speed = knockback_force
		current_state = States.Destroyed
		velocity = direction * knockback_force
		
func handle_air_time(delta: float) -> void:
	if current_state == States.Destroyed:
		height += height_speed * delta
		modulate.a -= delta
		if height < 0:
			height = 0
			queue_free()
		else:
			height_speed -= GRAVITY * delta
