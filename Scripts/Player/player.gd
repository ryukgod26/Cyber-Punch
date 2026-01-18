extends CharacterBody2D


@export var Health := 0
@export var Damage := 0
@export var Speed := 30

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	
	if direction != Vector2.ZERO:
		position += direction * delta * Speed
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("Idle")
	move_and_slide()
