extends Node
class_name DeathSavesManager

# Death save tracking
var death_saves_remaining := 3  # Three hearts
signal death_occurred
signal death_save_used(remaining: int)
signal game_over

func _ready() -> void:
	# Initialize with full death saves
	death_saves_remaining = 3

func take_death() -> bool:
	"""
	Handle a character death. Returns true if character can continue, false if game over.
	"""
	if death_saves_remaining <= 0:
		emit_signal("game_over")
		return false
	
	death_saves_remaining -= 1
	emit_signal("death_occurred")
	emit_signal("death_save_used", death_saves_remaining)
	
	print("Death! Death saves remaining: %d" % death_saves_remaining)
	
	# Drop unequipped items on death
	if Globals and Globals.inventory:
		Globals.inventory.clear_collected_items()
		print("Lost unequipped items on death!")
	
	return death_saves_remaining >= 0

func restore_death_saves() -> void:
	"""Restore all death saves (called on completing a new floor)"""
	death_saves_remaining = 3
	print("Death saves restored! Remaining: %d" % death_saves_remaining)
	emit_signal("death_save_used", death_saves_remaining)

func get_death_saves() -> int:
	"""Get remaining death saves"""
	return death_saves_remaining

func has_death_saves() -> bool:
	"""Check if character has any death saves left"""
	return death_saves_remaining > 0

func reset() -> void:
	"""Reset death saves (for new character)"""
	death_saves_remaining = 3
