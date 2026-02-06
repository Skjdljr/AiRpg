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
	
	# Drop loot if this is an enemy
	if owner.is_in_group("enemy") and Globals and Globals.inventory:
		var drop_roll = randf()
		if drop_roll < 0.30:  # 30% drop chance
			var loot_item = generate_random_loot()
			Globals.inventory.collect_item(loot_item)
	
	emit_signal("DiedEventHandler", owner)
	owner.queue_free()

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
	
