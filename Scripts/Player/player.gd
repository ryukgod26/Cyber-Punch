class_name Player
extends Character

@onready var enemy_slots: Array = $EnemySlots.get_children()


func handle_input() -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	velocity = direction * Speed

	if can_attack() and Input.is_action_just_pressed("attack"):
		current_state = States.Attack
		if is_last_attack_successfull:
			attack_combo_idx = (attack_combo_idx+1) % anim_attacks.size()
			is_last_attack_successfull = false
		else:
			attack_combo_idx = 0
	
	if can_jump() and Input.is_action_just_pressed("jump"):
		current_state = States.TakeOff
	
	if can_jump_kick() and Input.is_action_just_pressed("attack"):
		current_state = States.JumpKick

func reserve_slot(enemy: BaseEnemy) -> EnemySlot:
	var availaible_slots := enemy_slots.filter(
		func(slot): return slot.is_free()
	)
	if availaible_slots.size() == 0:
		return null
	
	availaible_slots.sort_custom(
		func(a: EnemySlot, b: EnemySlot):
			var dist_a := (enemy.global_position - a.global_position).length()
			var dist_b := (enemy.global_position - b.global_position).length()
			
			return dist_a < dist_b
	)
	availaible_slots[0].occupy(enemy)
	return availaible_slots[0]

func free_slot(enemy: BaseEnemy):
	var occupied_slot := enemy_slots.filter(
		func(slot: EnemySlot):
			return slot.occupanct ==  enemy
	)
	if occupied_slot.size() == 1:
		occupied_slot[0].free_the_slot()


func _on_fall_timer_timeout() -> void:
	current_state = States.Land
