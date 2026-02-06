extends Node
class_name Spell 

@export var spellName := "Base spell"
#@export var damage := 10 - get this from the damage component
#@export var mana_cost := 5 # - get this from the mana component
#@export var cooldown_time := 1.0 # - get this from the cooldown component
@export var target:Node2D	# - get this from the target component
@export var effects : Array[Effect]

# attacker
# deffender

func startCasting() -> void:
	# separate out the start effects via tags?
	#e in effects where e.has_method("on_start_casting")
	apply_effects()

func casting_complete() -> void:
	# separate out the complete effects
	#e in effects where e.has_method("on_casting_complete")
	apply_effects()

func apply_effects() -> void: 
	for e in effects:
		e.apply_effect(target);
