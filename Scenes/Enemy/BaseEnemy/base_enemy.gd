class_name BaseEnemy
extends Character

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	$DamageEmitter.area_entered.connect(_on_damage_emitter_area_entered)
	current_health = Health
	print(knockback_force)

func handle_input() -> void:
	if player != null and can_move():
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * Speed
