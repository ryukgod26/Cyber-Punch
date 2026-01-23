class_name BaseEnemy
extends Character

var player:Player
var player_slot:EnemySlot

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	$DamageEmitter.area_entered.connect(_on_damage_emitter_area_entered)
	current_health = Health

func handle_input() -> void:
	if player != null and can_move():
		if player_slot == null:
			player_slot = player.reserve_slot(self)
		else:
			var direction = (player_slot.global_position - global_position).normalized()
			if (player_slot.global_position - position).length() < 1:
				velocity = Vector2.ZERO
			else:
				velocity = direction * Speed

func hit(damage: int, direction: Vector2, hit_type:DamageReceiver.HitType) ->void:
	super.hit(damage,direction,hit_type)
	if current_health == 0:
		player.free_slot(self)


func _on_fall_timer_timeout() -> void:
	if current_state == States.Grounded:
		if current_health <= 0:
			current_state = States.Death
			handle_death()
		else:
			current_state = States.Land
