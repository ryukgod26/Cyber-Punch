class_name Player
extends Character

func handle_input() -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	velocity = direction * Speed
	
	if can_attack() and Input.is_action_just_pressed("attack"):
		current_state = States.Attack
	
	if can_jump() and Input.is_action_just_pressed("jump"):
		current_state = States.TakeOff
	
	if can_jump_kixk() and Input.is_action_just_pressed("attack"):
		current_state = States.JumpKick
