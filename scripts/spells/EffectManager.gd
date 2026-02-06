# EffectManager.gd
extends Node

class_name EffectManager

func apply_effect(target : Node, effect : Effect ) -> void:
	#match effect:
		#is DamageEffect:
			#apply_damage(target, effect.damage_amount)
		#is FreezeEffect:
			#apply_freeze(target, effect.freeze_duration)
		#is BurnEffect:
			#apply_burn(target, effect.burn_damage, effect.burn_duration)
	print("JOEL Write this function apply_effect")

func apply_damage(target : Node, amount : float) -> void:
	if target.has_method("take_damage"):
		target.take_damage(amount)
		
func apply_freeze(target : Node, duration : float) -> void:
	if target.has_method("apply_freeze"):
		target.apply_freeze(duration)

func apply_burn(target : Node, damage : float, duration : float) -> void:
	if target.has_method("apply_burn"):
		target.apply_burn(damage, duration)
#TODO: effect manager - could be broken up even more so that, you can select the effects that you want to be applied to a speicific target
