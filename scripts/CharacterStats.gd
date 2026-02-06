extends Node
class_name CharacterStats

# Character class presets
var CLASSES = {
	"Mage": {
		"max_hp": 80,
		"max_mana": 150,
		"spell_damage": 20,
		"move_speed": 100,
		"mana_regen": 15.0,
		"description": "Master of the arcane. High mana, moderate health. Uses mana for powerful spells."
	}
}

# Future classes (Phase 2+)
# "Warrior": { ... },
# "Rogue": { ... },
# "Paladin": { ... }

var current_class: String = "Mage"
var character_data = {}

func _ready() -> void:
	# Initialize with Mage by default
	select_class("Mage")

func select_class(class_name: String) -> void:
	"""Select a character class and apply stats"""
	if not CLASSES.has(class_name):
		push_error("Class '%s' not found!" % class_name)
		return
	
	current_class = class_name
	var class_stats = CLASSES[class_name]
	
	print("Selected class: %s" % class_name)
	
	# Apply to player
	if Globals and Globals.player:
		apply_stats_to_player(class_stats)
	
	# Store for reference
	character_data = class_stats.duplicate()

func apply_stats_to_player(stats: Dictionary) -> void:
	"""Apply stat dictionary to player character"""
	if not Globals or not is_instance_valid(Globals.player):
		return
	
	# Set movement speed
	Globals.player.move_speed = stats.move_speed
	
	# Set health
	if Globals.player.has_node("Components/HealthComponent"):
		var health_comp = Globals.player.get_node("Components/HealthComponent")
		health_comp.SetMaxHealth(stats.max_hp)
		health_comp.SetHealth(stats.max_hp)
	
	# Set mana
	if Globals.player.has_node("Components/ManaComponent"):
		var mana_comp = Globals.player.get_node("Components/ManaComponent")
		mana_comp.set_max_mana(stats.max_mana)
		mana_comp.restore_mana()
		mana_comp.mana_regen_rate = stats.mana_regen
	
	# Set spell damage
	Globals.player.spell_damage = stats.spell_damage

func get_class_description(class_name: String) -> String:
	"""Get description of a class"""
	if CLASSES.has(class_name):
		return CLASSES[class_name].description
	return ""

func get_all_classes() -> Array:
	"""Return list of available classes"""
	return CLASSES.keys()

func get_current_class_stats() -> Dictionary:
	"""Get current class stats"""
	return CLASSES[current_class].duplicate()

func scale_stats_for_floor(floor_num: int) -> Dictionary:
	"""Optional: Scale stats up for higher floors"""
	var base_stats = get_current_class_stats()
	
	# Soft scaling: +5% per floor above 1
	var scale_factor = 1.0 + (0.05 * (floor_num - 1))
	
	base_stats.max_hp = int(base_stats.max_hp * scale_factor)
	base_stats.max_mana = int(base_stats.max_mana * scale_factor)
	base_stats.spell_damage = int(base_stats.spell_damage * scale_factor)
	
	return base_stats
