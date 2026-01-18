extends CharacterBody2D


@export var Health := 0
@export var Damage := 0
@export var Speed := 30

@onready var character_sprite: Sprite2D = $CharacterSprite

enum States {Idle, Walk}

var current_state := States.Idle

func _physics_process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	handle_sprite_direction()
	move_and_slide()

func handle_movement():
	if velocity == Vector2.ZERO:
		current_state = States.Idle
	else:
		current_state = States.Walk

func handle_input() -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	velocity = direction * Speed
	
func handle_animation() -> void:
	if current_state == States.Idle:
		$AnimationPlayer.play("Idle")
	if current_state == States.Walk:
		$AnimationPlayer.play("walk")

func handle_sprite_direction() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
	elif velocity.x < 0:
		character_sprite.flip_h = true
