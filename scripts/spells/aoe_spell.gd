extends Area2D

class_name AoeSpell

@export var damage := 10 # should be a component
@export var radius := 100 # should be a component
@export var damage_cooldown := 1.0 
var _damageCooldown:Timer
var _enemies :Array[Node2D]

	#private void OnBodyExited(Node3D body)
	#{
	#	if (body is not Enemy enemy) return;
	#	_enemies.Remove(enemy);
	#}

	# private void OnBodyEntered(Node2D body)
	# {
	# 	if (body is not Enemy enemy) return;
	# 	_enemies.Add(enemy);
	# }

	# private void OnDamageReady()
	# {
	# 	_damageCooldown.Start();
	# 	foreach (var enemy in _enemies)
	# 		enemy.TakeDamages(TotalDamages);
	# }
