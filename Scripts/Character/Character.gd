class_name Character
extends CharacterBody2D

@export var Health: int
@export var Damage := 0
@export var Speed := 30
@export var Jump_Velocity := 150
@export var knockback_force: int

@onready var character_sprite: Sprite2D = $CharacterSprite

const GRAVITY := 600

enum States {Idle, Walk, Attack, TakeOff, Jump, Land, JumpKick, Hurt}

var current_health := 0
var current_state := States.Idle
var height := 0.
var height_speed := 0.
var anim_map :={
	States.Idle : "Idle",
	States.Walk: "Walk",
	States.Attack: "Punch",
	States.TakeOff: "Takeoff",
	States.Jump: "Jump",
	States.Land: "Land",
	States.JumpKick: "JumpKick",
	States.Hurt: "Hurt"
}

func _ready() -> void:
	$DamageEmitter.area_entered.connect(_on_damage_emitter_area_entered)
	current_health = Health

func _physics_process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	handle_sprite_direction()
	handle_air_time(delta)
	$CharacterSprite.position = Vector2.UP * height
	move_and_slide()

func handle_movement():
	if can_move():
		if velocity == Vector2.ZERO:
			current_state = States.Idle
		else:
			current_state = States.Walk

func handle_input() -> void:
	pass

func handle_animation() -> void:
	if $AnimationPlayer.has_animation(anim_map[current_state]):
		$AnimationPlayer.play(anim_map[current_state])
	else :
		print_debug("Trying to Play %s Animation Which Does not Exist" % anim_map[current_state])

func handle_sprite_direction() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
		$DamageEmitter/CollisionShape2D.position.x = 10
	elif velocity.x < 0:
		character_sprite.flip_h = true
		$DamageEmitter/CollisionShape2D.position.x = -10

func can_attack() -> bool:
	#Might Change the Logic in future due to extra states
	return current_state == States.Idle or current_state == States.Walk

func can_move() -> bool:
	#Might Change the Logic in future due to extra states
	return current_state == States.Idle or current_state == States.Walk

func can_jump() -> bool:
	return current_state == States.Idle or current_state == States.Walk

func can_jump_kixk() -> bool:
	return current_state == States.Jump

func on_action_complete() -> void:
	current_state = States.Idle

func _on_damage_emitter_area_entered(area: Area2D) -> void:
	if area is DamageReceiver:
		var direction := Vector2.LEFT if area.global_position.x < global_position.x else Vector2.RIGHT
		area.hit(Damage,direction)

func on_takeoff_complete() -> void:
	current_state = States.Jump
	height_speed = Jump_Velocity

func on_jumpkick_complete() -> void:
	if height > 0:
		current_state = States.Jump
	else:
		current_state = States.Land

func on_land_complete() -> void:
	current_state = States.Idle

func handle_air_time(delta: float) -> void:
	if current_state == States.Jump or current_state == States.JumpKick:
		height += height_speed * delta
		if height <0:
			height = 0
			current_state = States.Land
		else:
			height_speed -= GRAVITY * delta

func hit(damage, direction) -> void:
	current_health -= damage
	if current_health <= 0:
		queue_free()
	else:
		current_state = States.Hurt
		velocity = knockback_force * direction
