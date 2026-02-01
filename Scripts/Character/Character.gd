class_name Character
extends CharacterBody2D

@export var Can_Respawn:bool
@export var Health: int
@export var Damage := 0
@export var DAMAGE_POWER: int
@export var Speed := 30
@export var Jump_Velocity := 150
@export var Flight_Velocity: int
@export var knockback_force: int
@export var knockdown_force: int
@export var Fall_Timer:Timer
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var colleteral_damage_emitter: Area2D = $ColleteralDamageEmitter

const GRAVITY := 600

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

enum States {Idle, Walk, Attack, TakeOff, Jump, Land, JumpKick, Hurt, Fall, Grounded, Death, Fly}

var current_health := 0
var current_state := States.Idle
var height := 0.
var height_speed := 0.
var anim_attacks = ['Punch','PunchAlt','Kick', 'RoundKick']
var anim_map :={
	States.Idle : "Idle",
	States.Walk: "Walk",
	States.Attack: "Punch",
	States.TakeOff: "Takeoff",
	States.Jump: "Jump",
	States.Land: "Land",
	States.JumpKick: "JumpKick",
	States.Hurt: "Hurt",
	States.Fall: "Fall",
	States.Grounded: "Grounded",
	States.Death: "Grounded",
	States.Fly: "Fly",
}
var attack_combo_idx := 0
var is_last_attack_successfull := false

func _ready() -> void:
	$DamageEmitter.area_entered.connect(_on_damage_emitter_area_entered)
	current_health = Health
	Fall_Timer.timeout.connect(fall_timer_timeout)
	colleteral_damage_emitter.area_entered.connect(on_collateral_damage)
	colleteral_damage_emitter.body_entered.connect(on_wall_hit)

func _physics_process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	handle_sprite_direction()
	handle_air_time(delta)
	$CharacterSprite.position = Vector2.UP * height
	collision_shape.disabled = is_collision_disabled()
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
	if current_state == States.Attack:
		$AnimationPlayer.play(anim_attacks[attack_combo_idx])
	elif $AnimationPlayer.has_animation(anim_map[current_state]):
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

func can_jump_kick() -> bool:
	return current_state == States.Jump

func can_get_hurt() -> bool:
	return [States.Idle,States.Walk,States.Attack,States.TakeOff,States.Jump,States.Land,].has(current_state)

func on_action_complete() -> void:
	current_state = States.Idle

func _on_damage_emitter_area_entered(area: Area2D) -> void:
	if area is DamageReceiver:
		var hit_type := DamageReceiver.HitType.NORMAL
		var cur_damage = Damage
		if current_state == States.JumpKick:
			hit_type = DamageReceiver.HitType.KNOCKDOWN
		if attack_combo_idx == anim_attacks.size() - 1:
			hit_type = DamageReceiver.HitType.POWER
			cur_damage = DAMAGE_POWER
			print("Power Punch")
		
		var direction := Vector2.LEFT if area.global_position.x < global_position.x else Vector2.RIGHT
		area.hit(cur_damage,direction,hit_type)
		is_last_attack_successfull = true

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
	if [States.Jump,States.JumpKick,States.Fall].has(current_state):
		height += height_speed * delta
		if height <0:
			height = 0
			if current_state == States.Fall:
				current_state = States.Grounded
				$Timers/FallTimer.start()
				print("Timer Started")
			else:
				current_state = States.Land
			velocity = Vector2.ZERO
		else:
			height_speed -= GRAVITY * delta

func hit(damage, direction,hit_type:DamageReceiver.HitType) -> void:
	if can_get_hurt():
		current_health -= damage
		if hit_type == DamageReceiver.HitType.KNOCKDOWN:
			current_state = States.Fall
			height_speed = knockdown_force
			velocity = knockback_force * direction
		elif hit_type == DamageReceiver.HitType.POWER:
			current_state = States.Fly
			velocity = Flight_Velocity * direction
		else:
			current_state = States.Hurt
			velocity = knockback_force * direction
		if current_health <=0:
			current_state = States.Death
			handle_death()

func fall_timer_timeout() -> void:
	print("timeout")
	current_state = States.Land

func handle_death() -> void:
	if current_state == States.Death and not Can_Respawn:
		velocity = Vector2.ZERO
		print("Death Called")
		var tween = create_tween()
		tween.tween_property(self,"modulate:a",0,2)
		tween.tween_callback(queue_free)
	else:
		print("Function Called")
		current_state = States.Land

func is_collision_disabled() -> bool:
	return current_state == States.Grounded or current_state == States.Death or current_state == States.Fly

func on_collateral_damage(receiver: DamageReceiver) -> void:
	var dir := Vector2.LEFT if receiver.global_position.x < global_position.x else Vector2.RIGHT
	receiver.hit(0,dir,DamageReceiver.HitType.KNOCKDOWN)

func on_wall_hit(wall: AnimatableBody2D) -> void:
	current_state = States.Fall
	height_speed = knockdown_force
	velocity = -velocity/2.
