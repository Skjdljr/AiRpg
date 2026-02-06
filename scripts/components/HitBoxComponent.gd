@tool
extends Area2D
class_name HitBoxComponent
@export var health_component : HealthComponent

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = PackedStringArray()
	if health_component == null:
		warnings.append("health_component not set for HitBoxComponent")
	return warnings

func damage(amount : float) -> void:
	if health_component != null and health_component.has_method("TakeDamage"):
		health_component.TakeDamage(amount)
