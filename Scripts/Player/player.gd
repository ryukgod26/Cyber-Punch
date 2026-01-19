extends CharacterBody2D


@export var Health := 0
@export var Damage := 0
@export var Speed := 30

@onready var character_sprite: Sprite2D = $CharacterSprite

enum States {Idle, Walk, Attack}

var current_state := States.Idle

func _physics_process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	handle_sprite_direction()
	move_and_slide()

func handle_movement():
	if can_move():
		if velocity == Vector2.ZERO:
			current_state = States.Idle
		else:
			current_state = States.Walk
	else:
		velocity = Vector2.ZERO

func handle_input() -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	velocity = direction * Speed
	
	if can_attack() and Input.is_action_just_pressed("attack"):
		current_state = States.Attack
	
func handle_animation() -> void:
	if current_state == States.Idle:
		$AnimationPlayer.play("Idle")
	elif current_state == States.Walk:
		$AnimationPlayer.play("walk")
	elif current_state == States.Attack:
		$AnimationPlayer.play("punch")

func handle_sprite_direction() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
	elif velocity.x < 0:
		character_sprite.flip_h = true

func can_attack() -> bool:
	#Might Change the Logic in future due to extra states
	return current_state == States.Idle or current_state == States.Walk

func can_move() -> bool:
	#Might Change the Logic in future due to extra states
	return current_state == States.Idle or current_state == States.Walk

func attack_complete() -> void:
	current_state = States.Idle
