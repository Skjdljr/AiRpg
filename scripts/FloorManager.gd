extends Node
class_name FloorManager

# Floor configuration
@export var enemy_scene: PackedScene  # Reference to enemy scene to spawn
@export var current_floor: int = 1
@export var max_floors: int = 10

# Wave management
var waves: Array[Array] = []  # Each element is array of enemies in wave
var current_wave: int = 0
var enemies_alive: Array[Node] = []

# Signals
signal wave_started
signal wave_completed
signal floor_completed
signal floor_changed

# Floor difficulty scaling
var floor_config = {
	1: {hp: 30, damage: 5, waves: [5, 8, 1]},
	2: {hp: 35, damage: 6, waves: [5, 8, 1]},
	3: {hp: 40, damage: 7, waves: [5, 8, 1]},
	4: {hp: 60, damage: 10, waves: [8, 12, 1]},
	5: {hp: 70, damage: 11, waves: [8, 12, 1]},
	6: {hp: 80, damage: 12, waves: [8, 12, 1]},
	7: {hp: 100, damage: 15, waves: [8, 12, 1]},
	8: {hp: 120, damage: 18, waves: [10, 15, 2]},
	9: {hp: 150, damage: 22, waves: [10, 15, 2]},
	10: {hp: 180, damage: 25, waves: [10, 15, 2]},
}

func _ready() -> void:
	if not enemy_scene:
		push_error("FloorManager: enemy_scene not set!")
		return
	
	setup_floor(current_floor)

func _process(_delta: float) -> void:
	# Check if all enemies in wave are dead
	update_alive_enemies()
	if enemies_alive.is_empty() and current_wave > 0:
		complete_current_wave()

func setup_floor(floor_num: int) -> void:
	"""Initialize floor with proper difficulty"""
	current_floor = clamp(floor_num, 1, max_floors)
	current_wave = 0
	enemies_alive.clear()
	
	print("Setting up Floor %d" % current_floor)
	emit_signal("floor_changed")
	start_next_wave()

func start_next_wave() -> void:
	"""Start the next wave of enemies"""
	current_wave += 1
	
	# Safety check
	if not floor_config.has(current_floor):
		push_error("Floor config not found for floor %d" % current_floor)
		return
	
	var config = floor_config[current_floor]
	
	# Check if this wave exists
	if current_wave > config.waves.size():
		complete_floor()
		return
	
	var wave_size = config.waves[current_wave - 1]
	var boss_wave = (current_wave == config.waves.size())
	
	print("Wave %d: Spawning %d enemies (Boss: %s)" % [current_wave, wave_size, boss_wave])
	
	for i in range(wave_size):
		spawn_enemy(config.hp, config.damage, boss_wave)
	
	emit_signal("wave_started")

func spawn_enemy(hp: int, damage: int, is_boss: bool) -> void:
	"""Spawn a single enemy with stats"""
	if not enemy_scene:
		return
	
	var enemy = enemy_scene.instantiate()
	
	# Apply stats scaling
	if is_boss:
		hp = int(hp * 3.0)  # Boss has 3x HP
		damage = int(damage * 1.5)  # Boss has 1.5x damage
	
	# Configure enemy health
	if enemy.has_node("Components/HealthComponent"):
		var health_comp = enemy.get_node("Components/HealthComponent")
		health_comp.SetMaxHealth(hp)
		health_comp.SetHealth(hp)
	
	# Configure enemy damage (TODO: when damage system is added)
	# TODO: Apply damage value to enemy attack
	
	# Add to scene
	get_parent().add_child(enemy)
	enemies_alive.append(enemy)

func update_alive_enemies() -> void:
	"""Remove dead enemies from tracking"""
	enemies_alive = enemies_alive.filter(func(e): return is_instance_valid(e))

func complete_current_wave() -> void:
	"""Called when all enemies in wave are defeated"""
	print("Wave %d completed!" % current_wave)
	emit_signal("wave_completed")
	
	var config = floor_config[current_floor]
	if current_wave < config.waves.size():
		# More waves to come
		await get_tree().create_timer(2.0).timeout  # 2 second pause between waves
		start_next_wave()
	else:
		complete_floor()

func complete_floor() -> void:
	"""Called when floor is fully completed"""
	print("Floor %d completed!" % current_floor)
	emit_signal("floor_completed")
	
	# Restore player health and reset skills for ease of testing
	if Globals.player and Globals.player.has_node("Components/HealthComponent"):
		var health_comp = Globals.player.get_node("Components/HealthComponent")
		health_comp.SetHealth(int(health_comp.GetMaxHealth()))
	
	# Try to move to next floor
	if current_floor < max_floors:
		await get_tree().create_timer(3.0).timeout
		setup_floor(current_floor + 1)

func get_floor_config(floor_num: int) -> Dictionary:
	"""Get configuration for a specific floor"""
	if floor_config.has(floor_num):
		return floor_config[floor_num]
	return {}

func get_progress() -> String:
	"""Return current progress string"""
	return "Floor: %d | Wave: %d" % [current_floor, current_wave]
