extends Node
class_name Inventory

# Inventory signals
signal item_collected(item: ItemDropManager.LootItem)
signal item_dropped(item: ItemDropManager.LootItem)
signal item_equipped(slot: String, item: ItemDropManager.LootItem)
signal inventory_changed

# Collected items (items sitting on the ground not yet equipped)
var collected_items: Array[ItemDropManager.LootItem] = []

# Equipped items (currently active bonuses)
var equipped_items: Dictionary = {
	"Weapon": null,
	"Armor": null,
	"Accessory": null,
}

# Active stat bonuses from equipped items
var active_bonuses: Dictionary = {
	"damage": 0,
	"hp": 0,
	"cooldown_reduction": 0.0,
}

func _ready() -> void:
	# Initialize equipped items to null
	for slot in equipped_items.keys():
		equipped_items[slot] = null

func collect_item(item: ItemDropManager.LootItem) -> void:
	"""Add item to collected items"""
	if item == null:
		return
	
	collected_items.append(item)
	emit_signal("item_collected", item)
	emit_signal("inventory_changed")
	
	print("Collected: %s (%s)" % [item.name, item.rarity])
	
	# Auto-equip if better than current
	auto_equip_if_better(item)

func auto_equip_if_better(item: ItemDropManager.LootItem) -> void:
	"""Equip item if it's better than current in that slot"""
	var current_equipped = equipped_items[item.slot]
	
	# If no item equipped yet, equip
	if current_equipped == null:
		equip_item(item)
		return
	
	# Compare stat bonuses
	var current_stat_value = get_item_stat_value(current_equipped)
	var new_stat_value = get_item_stat_value(item)
	
	if new_stat_value > current_stat_value:
		# Unequip current and drop it back to collected
		collected_items.append(current_equipped)
		equip_item(item)
		# Remove from collected
		collected_items.erase(item)

func equip_item(item: ItemDropManager.LootItem) -> void:
	"""Equip an item to the appropriate slot"""
	if item == null:
		return
	
	var slot = item.slot
	
	# Apply bonuses to player
	apply_item_bonuses(item, true)
	
	# Update equipped items
	equipped_items[slot] = item
	
	emit_signal("item_equipped", slot, item)
	emit_signal("inventory_changed")
	
	print("Equipped: %s in %s slot" % [item.name, slot])

func unequip_item(slot: String) -> void:
	"""Unequip an item from a slot"""
	if not equipped_items.has(slot):
		return
	
	var item = equipped_items[slot]
	if item == null:
		return
	
	# Remove bonuses
	apply_item_bonuses(item, false)
	
	# Move to collected items
	collected_items.append(item)
	equipped_items[slot] = null
	
	emit_signal("inventory_changed")
	print("Unequipped: %s from %s slot" % [item.name, slot])

func apply_item_bonuses(item: ItemDropManager.LootItem, apply: bool) -> void:
	"""Apply or remove item stat bonuses"""
	var multiplier = 1 if apply else -1
	
	for stat in item.stat_bonuses.keys():
		if stat in active_bonuses:
			active_bonuses[stat] += item.stat_bonuses[stat] * multiplier
	
	# Apply to player
	if Globals.player:
		apply_bonuses_to_player()

func apply_bonuses_to_player() -> void:
	"""Apply all active bonuses to the player"""
	if not Globals or not Globals.player:
		return
	
	# Health bonus
	if Globals.player.has_node("Components/HealthComponent"):
		var health_comp = Globals.player.get_node("Components/HealthComponent")
		var base_hp = 80  # Mage base HP
		var total_hp = base_hp + active_bonuses.get("hp", 0)
		health_comp.SetMaxHealth(int(total_hp))
	
	# Damage bonus
	if "spell_damage" in Globals.player:
		Globals.player.spell_damage = 20 + active_bonuses.get("damage", 0)
	
	# Cooldown reduction bonus (applied to skill cooldowns)
	if "cooldown_reduction" in Globals.player:
		Globals.player.cooldown_reduction = active_bonuses.get("cooldown_reduction", 0.0)

func get_item_stat_value(item: ItemDropManager.LootItem) -> int:
	"""Calculate total stat value for comparison"""
	var total = 0
	for stat_value in item.stat_bonuses.values():
		if stat_value is float:
			total += int(stat_value * 100)  # Scale floats for comparison
		else:
			total += stat_value
	return total

func clear_collected_items() -> void:
	"""Clear collected items (used when moving to next floor)"""
	collected_items.clear()
	emit_signal("inventory_changed")
	print("Cleared collected items")

func clear_all() -> void:
	"""Complete inventory reset"""
	collected_items.clear()
	equipped_items = {"Weapon": null, "Armor": null, "Accessory": null}
	active_bonuses = {"damage": 0, "hp": 0, "cooldown_reduction": 0.0}
	emit_signal("inventory_changed")

func get_collected_count() -> int:
	"""Get number of collected but unequipped items"""
	return collected_items.size()

func get_equipped_item(slot: String) -> ItemDropManager.LootItem:
	"""Get currently equipped item in slot"""
	if equipped_items.has(slot):
		return equipped_items[slot]
	return null

func get_all_collected() -> Array[ItemDropManager.LootItem]:
	"""Get array of all collected items"""
	return collected_items

func get_all_equipped() -> Dictionary:
	"""Get all equipped items"""
	return equipped_items.duplicate()

func print_inventory() -> void:
	"""Debug print current inventory"""
	print("\n=== INVENTORY ===")
	print("Equipped:")
	for slot in equipped_items.keys():
		if equipped_items[slot]:
			var item = equipped_items[slot]
			print("  %s: %s (%s)" % [slot, item.name, item.rarity])
		else:
			print("  %s: (empty)" % slot)
	
	print("Collected (%d items):" % collected_items.size())
	for item in collected_items:
		print("  - %s (%s)" % [item.name, item.rarity])
	
	print("Active Bonuses:")
	for stat in active_bonuses.keys():
		print("  %s: %s" % [stat, active_bonuses[stat]])
	print("================\n")
