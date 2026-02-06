extends Node
class_name ManaComponent

@export var maxMana := 100.0
@export var mana_regen_rate := 10.0  # Mana per second

var currentMana := 100.0
signal mana_changed(new_mana: float)

func _ready() -> void:
	currentMana = maxMana

func _process(delta: float) -> void:
	# Passive mana regeneration
	if currentMana < maxMana:
		add_mana(mana_regen_rate * delta)

func get_mana() -> float:
	return currentMana

func get_max_mana() -> float:
	return maxMana

func get_mana_percentage() -> float:
	if maxMana > 0:
		return currentMana / maxMana
	return 0.0

func has_mana(amount: float) -> bool:
	return currentMana >= amount

func use_mana(amount: float) -> bool:
	"""Attempt to use mana. Returns true if successful."""
	if currentMana >= amount:
		set_mana(currentMana - amount)
		return true
	return false

func add_mana(amount: float) -> void:
	set_mana(currentMana + amount)

func set_mana(amount: float) -> void:
	currentMana = clamp(amount, 0, maxMana)
	emit_signal("mana_changed", currentMana)

func set_max_mana(new_max: float) -> void:
	maxMana = new_max
	currentMana = clamp(currentMana, 0, maxMana)

func restore_mana() -> void:
	"""Full mana restore (for floor completion)"""
	currentMana = maxMana
	emit_signal("mana_changed", currentMana)
