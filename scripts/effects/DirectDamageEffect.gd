class_name DirectDamageEffect extends Effect

@export var damage_amount: int

func apply_effect(target: Node2D) -> void:
	print("Apply " + str(damage_amount) + " damage to " + target.name)
	
