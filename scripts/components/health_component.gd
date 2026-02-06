@tool
extends Node
class_name HealthComponent
signal DiedEventHandler

@export var healthBar : ProgressBar = null
@export var healthLabel : Label = null
@export var maxHealth := 100.0
@export var suppressDamage := false
@export var showHealthBar := true
@export var showHealthText := true

# Boss loot flag
var is_boss_dropping_loot := false

@onready var currentHealth := maxHealth
signal damaged

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = PackedStringArray()
	if healthLabel == null:
		warnings.append("HealthLabel not set for..")
	if healthBar == null:
		warnings.append("HealthBar not set for..")
	return warnings

func _ready() -> void:
	setProgressBar()
	if healthLabel != null :
		healthLabel.text = str(currentHealth)
		
	if healthBar != null:
		healthBar.value = currentHealth

func HasHealthRemaining() -> bool:
	return is_equal_approx(currentHealth, 0.0)

func GetHealthPercentage() -> float:
	if maxHealth > 0:
		return currentHealth / maxHealth
	else:
		return 0
		
func GetMaxHealth() -> float:
	return maxHealth

func GetHealth() -> float:
	return currentHealth

func SetHealth(health: float) -> void:
	if health <= 0:
		currentHealth = 0
		Die()
	elif health > maxHealth:
		currentHealth = maxHealth
	else:
		currentHealth = health

	if healthLabel != null:
		healthLabel.text = str(currentHealth)
	if healthBar != null:
		healthBar.value = currentHealth

func TakeDamage(damage: float) -> void:
	if !suppressDamage:
		emit_signal("damaged", damage)
		SetHealth(GetHealth() - damage)
		
func Heal(health: int) -> void: 
	SetHealth(GetHealth() + health)

func SetMaxHealth(newMaxHealth: int) -> void:
	maxHealth = newMaxHealth
	SetHealth(currentHealth)

func Die() -> void:
	print(owner.name + " DIED!")
	
	# Check if this is the player dying
	if owner == Globals.player:
		handle_player_death()
	elif owner.is_in_group("enemy") and Globals and Globals.inventory:
		# Regular enemy: drop loot
		handle_enemy_death()
	
	emit_signal("DiedEventHandler", owner)
	owner.queue_free()

func handle_player_death() -> void:
	"""Handle player death with death saves system"""
	if not Globals or not Globals.death_saves_manager:
		return
	
	# Use a death save
	var can_continue = Globals.death_saves_manager.take_death()
	
	if not can_continue:
		# Game over - third death
		print("GAME OVER! No more death saves!")
		# TODO: Load game over screen
		get_tree().paused = true
		return
	
	# Player can continue - show death options screen
	show_death_options_screen()

func handle_enemy_death() -> void:
	"""Handle enemy death and loot drops"""
	if is_boss_dropping_loot:
		# Boss: guaranteed rare+ drops (2-4 items)
		var drop_count = randi_range(2, 4)
		for i in range(drop_count):
			var loot_item = generate_boss_loot()
			Globals.inventory.collect_item(loot_item)
		print("Boss dropped %d items!" % drop_count)
	else:
		# Regular enemy: 30% chance for one random item
		var drop_roll = randf()
		if drop_roll < 0.30:
			var loot_item = generate_random_loot()
			Globals.inventory.collect_item(loot_item)

func show_death_options_screen() -> void:
	"""Show UI for player to choose: Retry Floor or Go Down a Level"""
	# TODO: Create a proper UI panel with buttons
	# For now, just print the options (will be replaced with UI)
	print("\n=== DEATH OPTIONS ===")
	print("Press R to RETRY current floor")
	print("Press B to GO DOWN 1 level")
	print("=== SELECT AN OPTION ===\n")
	
	# Store that we're waiting for input
	if Globals and Globals.player:
		Globals.player.awaiting_death_choice = true

func generate_random_loot() -> ItemDropManager.LootItem:
	"""Generate a random loot item"""
	var rarity_roll = randf()
	var rarity = "Common"
	
	if rarity_roll < 0.70:
		rarity = "Common"
	elif rarity_roll < 0.95:
		rarity = "Rare"
	else:
		rarity = "Legendary"
	
	# Simple loot generation - choose random item of that rarity
	var loot_names_by_rarity = {
		"Common": ["Iron Dagger", "Bronze Sword", "Steel Mace", "Cloth Robe", "Leather Armor"],
		"Rare": ["Enchanted Blade", "Mithril Sword", "Dragon Scale Armor", "Arcane Focus"],
		"Legendary": ["Excalibur", "Sunblade", "Plate of the Ancients", "Crown of Power"]
	}
	
	var names = loot_names_by_rarity[rarity]
	var item_name = names[randi() % names.size()]
	
	# Create item with appropriate stats
	var stats = {}
	match item_name:
		"Iron Dagger": stats = {"damage": 5}
		"Bronze Sword": stats = {"damage": 7}
		"Steel Mace": stats = {"damage": 6}
		"Cloth Robe": stats = {"hp": 10}
		"Leather Armor": stats = {"hp": 15}
		"Enchanted Blade": stats = {"damage": 18}
		"Mithril Sword": stats = {"damage": 20}
		"Dragon Scale Armor": stats = {"hp": 35}
		"Arcane Focus": stats = {"damage": 10}
		"Excalibur": stats = {"damage": 50}
		"Sunblade": stats = {"damage": 45}
		"Plate of the Ancients": stats = {"hp": 80}
		"Crown of Power": stats = {"damage": 25}
		_: stats = {"damage": 5}
	
	# Determine slot
	var slot = "Weapon" if "damage" in stats else "Armor"
	
	return ItemDropManager.LootItem.new(item_name, rarity, slot, stats)

func generate_boss_loot() -> ItemDropManager.LootItem:
	"""Generate guaranteed rare+ loot for bosses"""
	var rarity_roll = randf()
	var rarity = "Rare"
	
	if rarity_roll < 0.60:
		rarity = "Rare"
	else:
		rarity = "Legendary"
	
	# Boss loot options
	var loot_names_by_rarity = {
		"Rare": ["Enchanted Blade", "Mithril Sword", "Dragon Scale Armor", "Arcane Focus", "Ring of Haste"],
		"Legendary": ["Excalibur", "Sunblade", "Plate of the Ancients", "Crown of Power", "Cloak of Shadows"]
	}
	
	var names = loot_names_by_rarity[rarity]
	var item_name = names[randi() % names.size()]
	
	# Create item with appropriate stats
	var stats = {}
	match item_name:
		"Enchanted Blade": stats = {"damage": 18}
		"Mithril Sword": stats = {"damage": 20}
		"Dragon Scale Armor": stats = {"hp": 35}
		"Arcane Focus": stats = {"damage": 10}
		"Ring of Haste": stats = {"cooldown_reduction": 0.15}
		"Excalibur": stats = {"damage": 50}
		"Sunblade": stats = {"damage": 45}
		"Plate of the Ancients": stats = {"hp": 80}
		"Crown of Power": stats = {"damage": 25}
		"Cloak of Shadows": stats = {"hp": 75}
		_: stats = {"damage": 20}
	
	# Determine slot
	var slot = "Weapon" if "damage" in stats else "Armor"
	
	return ItemDropManager.LootItem.new(item_name, rarity, slot, stats) 

func InitializeHealth() -> void:
	currentHealth = maxHealth

func ApplyScaling(_curve: Curve, _progress: float ) -> void:
	#callDeferred("ApplyScalingInternal", curve, progress)
	pass

func ApplyScalingInternal(curve : Curve, progress:float ) -> void:
	var curveVal : float = curve.sample((progress))
	maxHealth *= (1.0 + curveVal)
	currentHealth = maxHealth
	
func setProgressBar() -> void:
	var progressBar : ProgressBar = ProgressBar.new()
	
	# Set the size of the ProgressBar
	var size := Vector2(300, 25)
	progressBar.custom_minimum_size = Vector2(100,0)
	progressBar.set_size(size)
	
	progressBar.set_position(Vector2(100, 100)) # Position in the parent container

	# Set the range of the ProgressBar (e.g., 0 to 100)
	progressBar.min_value = 0
	progressBar.max_value = 100
	
	# Set the current value of the ProgressBar
	progressBar.value = 50  # Example value
	
	#owner.add_child(progressBar)
	
