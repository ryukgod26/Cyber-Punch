class_name BaseEnemy
extends Character

@export var duration_between_hits: int
@export var duration_prep_hit: int

@onready var attack_prep_timer: Timer = $Timers/AttackPrepTimer
@onready var attack_timer: Timer = $Timers/AttackTimer

var player:Player
var player_slot:EnemySlot

func _ready() -> void:
	super._ready()
	player = get_tree().get_first_node_in_group("Player")
	anim_attacks = []

func handle_input() -> void:
	if player != null and can_move():
		if player_slot == null:
			player_slot = player.reserve_slot(self)
		else:
			var direction = (player_slot.global_position - global_position).normalized()
			if is_player_within_range() and can_attack():
				velocity = Vector2.ZERO
				if can_attack():
					current_state = States.PREP_ATTACK
					attack_prep_timer.start()
			else:
				velocity = direction * Speed

func hit(damage: int, direction: Vector2, hit_type:DamageReceiver.HitType) ->void:
	super.hit(damage,direction,hit_type)
	print(current_state)
	if current_health == 0:
		player.free_slot(self)

func _on_fall_timer_timeout() -> void:
	if current_state == States.Grounded:
		if current_health <= 0:
			current_state = States.Death
			handle_death()
		else:
			current_state = States.Land

func set_heading() -> void:
	if global_position.direction_to(player.global_position).x > 0:
		heading = Vector2.RIGHT
	elif global_position.direction_to(player.global_position).x < 0:
		heading = Vector2.LEFT

func is_player_within_range() -> bool:
	return (player_slot.global_position - global_position).length() < 1

func can_attack() -> bool:
	if attack_prep_timer.is_stopped():
		return super.can_attack()
	return false

func handle_prep_attack() -> void:
	if current_state == States.PREP_ATTACK and attack_prep_timer.is_stopped():
		current_state = States.Attack
