extends Node
class_name ItemDropManager

# Item definition
class LootItem:
	var name: String
	var rarity: String  # "Common", "Rare", "Legendary"
	var slot: String   # "Weapon", "Armor", "Accessory"
	var stat_bonuses: Dictionary  # {"damage": 5, "hp": 0, "cooldown_reduction": 0}
	
	func _init(p_name: String, p_rarity: String, p_slot: String, p_stats: Dictionary) -> void:
		name = p_name
		rarity = p_rarity
		slot = p_slot
		stat_bonuses = p_stats

# Loot table - defines all possible drops
var loot_table: Array[LootItem] = []

# Drop configuration
var drop_chance := 0.30  # 30% chance for enemy to drop loot
var loot_scene: PackedScene = preload("res://scenes/floating_text.tscn")  # TODO: Create actual loot scene

func _ready() -> void:
	generate_loot_table()

func generate_loot_table() -> void:
	"""Create the loot table with all possible items"""
	
	# Common Weapons (70% rarity weight)
	loot_table.append(LootItem.new("Iron Dagger", "Common", "Weapon", {"damage": 5}))
	loot_table.append(LootItem.new("Bronze Sword", "Common", "Weapon", {"damage": 7}))
	loot_table.append(LootItem.new("Steel Mace", "Common", "Weapon", {"damage": 6}))
	
	# Common Armor (70% rarity weight)
	loot_table.append(LootItem.new("Cloth Robe", "Common", "Armor", {"hp": 10}))
	loot_table.append(LootItem.new("Leather Armor", "Common", "Armor", {"hp": 15}))
	loot_table.append(LootItem.new("Iron Plate", "Common", "Armor", {"hp": 12}))
	
	# Common Accessories (70% rarity weight)
	loot_table.append(LootItem.new("Copper Ring", "Common", "Accessory", {"cooldown_reduction": 0.05}))
	loot_table.append(LootItem.new("Simple Amulet", "Common", "Accessory", {"damage": 3}))
	
	# Rare Weapons (25% rarity weight)
	loot_table.append(LootItem.new("Enchanted Blade", "Rare", "Weapon", {"damage": 18}))
	loot_table.append(LootItem.new("Mithril Sword", "Rare", "Weapon", {"damage": 20}))
	loot_table.append(LootItem.new("Runeblade", "Rare", "Weapon", {"damage": 22}))
	
	# Rare Armor (25% rarity weight)
	loot_table.append(LootItem.new("Dragon Scale Armor", "Rare", "Armor", {"hp": 35}))
	loot_table.append(LootItem.new("Mystic Plate", "Rare", "Armor", {"hp": 40}))
	loot_table.append(LootItem.new("Blessed Robes", "Rare", "Armor", {"hp": 38}))
	
	# Rare Accessories (25% rarity weight)
	loot_table.append(LootItem.new("Arcane Focus", "Rare", "Accessory", {"damage": 10}))
	loot_table.append(LootItem.new("Ring of Haste", "Rare", "Accessory", {"cooldown_reduction": 0.15}))
	
	# Legendary Weapons (5% rarity weight)
	loot_table.append(LootItem.new("Excalibur", "Legendary", "Weapon", {"damage": 50}))
	loot_table.append(LootItem.new("Sunblade", "Legendary", "Weapon", {"damage": 45}))
	
	# Legendary Armor (5% rarity weight)
	loot_table.append(LootItem.new("Plate of the Ancients", "Legendary", "Armor", {"hp": 80}))
	loot_table.append(LootItem.new("Cloak of Shadows", "Legendary", "Armor", {"hp": 75}))
	
	# Legendary Accessories (5% rarity weight)
	loot_table.append(LootItem.new("Crown of Power", "Legendary", "Accessory", {"damage": 25, "cooldown_reduction": 0.10}))

func attempt_drop(enemy: Node2D) -> void:
	"""Roll for item drop from defeated enemy. Called when enemy dies."""
	if randf() > drop_chance:
		return  # No drop this time
	
	# Pick random item
	var item = loot_table[randi() % loot_table.size()]
	
	# Spawn on ground at enemy location
	spawn_loot_at(item, enemy.global_position)

func spawn_loot_at(item: LootItem, position: Vector2) -> void:
	"""Spawn loot item on the ground"""
	print("Item dropped: %s (%s)" % [item.name, item.rarity])
	
	# TODO: Create actual loot item node that can be picked up
	# For now, just print so we can track drops
	# This will need to be a scene with an Area2D for pickup and visual representation
	
	# Signal for UI feedback
	if Inventory:
		Inventory.emit_signal("item_dropped", item)

func roll_item_rarity(floor_num: int = 1) -> String:
	"""Determine rarity based on floor difficulty"""
	var roll = randf()
	
	# Base rarity distribution
	if roll < 0.70:
		return "Common"
	elif roll < 0.95:
		return "Rare"
	else:
		return "Legendary"
	
	# Higher floors could improve this, but POC doesn't need scaling yet

func get_item_by_name(item_name: String) -> LootItem:
	"""Find item in loot table by name"""
	for item in loot_table:
		if item.name == item_name:
			return item
	return null

func get_items_by_slot(slot: String) -> Array[LootItem]:
	"""Get all items for a specific slot"""
	var result: Array[LootItem] = []
	for item in loot_table:
		if item.slot == slot:
			result.append(item)
	return result

func get_items_by_rarity(rarity: String) -> Array[LootItem]:
	"""Get all items with specific rarity"""
	var result: Array[LootItem] = []
	for item in loot_table:
		if item.rarity == rarity:
			result.append(item)
	return result
