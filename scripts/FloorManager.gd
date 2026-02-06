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
	# Early Game (Floors 1-3): Gentle difficulty
	1: {hp: 30, damage: 5, waves: [5, 8, 1]},
	2: {hp: 33, damage: 6, waves: [5, 8, 1]},
	3: {hp: 36, damage: 7, waves: [5, 8, 1]},
	
	# Mid Game (Floors 4-6): Moderate increase
	4: {hp: 50, damage: 10, waves: [8, 12, 1]},
	5: {hp: 60, damage: 12, waves: [8, 12, 1]},
	6: {hp: 70, damage: 14, waves: [8, 12, 1]},
	
	# Late Game (Floors 7-9): Steeper climb
	7: {hp: 90, damage: 17, waves: [10, 15, 1]},
	8: {hp: 110, damage: 20, waves: [10, 15, 1]},
	9: {hp: 130, damage: 23, waves: [10, 15, 2]},
	
	# Final Boss Floor (Floor 10): Significant jump
	10: {hp: 180, damage: 30, waves: [10, 15, 2]},
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
	
	# Update CharacterStats to track current floor
	if Globals and Globals.character_stats:
		Globals.character_stats.current_floor = current_floor
	
	var difficulty_tier = get_difficulty_tier(current_floor)
	print("\n=== FLOOR %d ===" % current_floor)
	print("Difficulty: %s" % difficulty_tier)
	
	var config = get_floor_config(current_floor)
	if config:
		print("Enemy HP: %d | Damage: %d" % [config.hp, config.damage])
	
	emit_signal("floor_changed")
	start_next_wave()

func get_difficulty_tier(floor_num: int) -> String:
	"""Get the difficulty tier for a floor"""
	match floor_num:
		1, 2, 3:
			return "🟢 Early Game (Beginner)"
		4, 5, 6:
			return "🟡 Mid Game (Moderate)"
		7, 8, 9:
			return "🔴 Late Game (Challenging)"
		10:
			return "⚫ Endgame (Extreme)"
		_:
			return "💀 Beyond (Nightmare)"

func start_next_wave() -> void:
	"""Start the next wave of enemies"""
	current_wave += 1
	
	# Safety check
	if not floor_config.has(current_floor) and current_floor <= 10:
		push_error("Floor config not found for floor %d" % current_floor)
		return
	
	var config = get_floor_config(current_floor)
	
	# Check if this wave exists
	if current_wave > config.waves.size():
		complete_floor()
		return
	
	var wave_size = config.waves[current_wave - 1]
	var boss_wave = (current_wave == config.waves.size())
	
	if boss_wave:
		print(">>> BOSS WAVE: Spawning %d boss enemies! <<<" % wave_size)
	else:
		print("Wave %d: %d enemies (HP: %d, DMG: %d)" % [current_wave, wave_size, config.hp, config.damage])
	
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
		enemy.is_boss = true
		enemy.boss_name = "Floor %d Boss" % current_floor
	
	# Configure enemy health
	if enemy.has_node("Components/HealthComponent"):
		var health_comp = enemy.get_node("Components/HealthComponent")
		health_comp.SetMaxHealth(hp)
		health_comp.SetHealth(hp)
		
		# Store boss flag in health component for loot purposes
		if is_boss:
			health_comp.is_boss_dropping_loot = true
	
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
	
	# Restore death saves on new floor completion
	if Globals and Globals.death_saves_manager:
		Globals.death_saves_manager.restore_death_saves()
		print("🟢 Unlocked Floor %d for farming!" % current_floor)
	
	# Try to move to next floor
	if current_floor < max_floors:
		await get_tree().create_timer(3.0).timeout
		setup_floor(current_floor + 1)

func get_floor_config(floor_num: int) -> Dictionary:
	"""Get configuration for a specific floor"""
	if floor_config.has(floor_num):
		return floor_config[floor_num]
	
	# For floors beyond 10, calculate dynamically
	if floor_num > 10:
		return calculate_floor_difficulty(floor_num)
	
	return {}

func calculate_floor_difficulty(floor_num: int) -> Dictionary:
	"""Calculate difficulty for floors beyond the preset configs"""
	# Base off floor 10 and scale from there
	var base_hp = 180.0
	var base_damage = 30.0
	
	# Scale: +15% per floor after 10 (could be adjusted)
	var scale_multiplier = pow(1.15, float(floor_num - 10))
	
	var hp = int(base_hp * scale_multiplier)
	var damage = int(base_damage * scale_multiplier)
	
	# Wave sizes also increase slightly
	var wave1 = max(10, 10 + (floor_num - 10))
	var wave2 = max(15, 15 + (floor_num - 10))
	var wave3 = 2 + (floor_num - 11)  # More bosses on later floors
	
	return {
		"hp": hp,
		"damage": damage,
		"waves": [wave1, wave2, wave3]
	}

func get_progress() -> String:
	"""Return current progress string"""
	return "Floor: %d | Wave: %d" % [current_floor, current_wave]

func print_difficulty_curve() -> void:
	"""Debug function to show the full difficulty progression"""
	print("\n" + "=".repeat(60))
	print("DIFFICULTY PROGRESSION CURVE")
	print("=".repeat(60))
	
	for floor in range(1, 11):
		var config = get_floor_config(floor)
		var tier = get_difficulty_tier(floor)
		var scale = pow(1.0 + (float(floor - 1) * 0.05), 1.0)  # Approximate scale
		
		print("Floor %2d | %s | HP: %3d | DMG: %2d | Scale: %.2fx" % [
			floor,
			tier,
			config.hp,
			config.damage,
			scale
		])
	
	print("=".repeat(60) + "\n")
