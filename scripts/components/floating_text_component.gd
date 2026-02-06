@tool
extends Marker2D
class_name FloatingTextComponent
@export var health_component : HealthComponent

const TEXT_SCENE = preload("res://scenes/floating_text.tscn")
@export var floatingText : PackedScene  = TEXT_SCENE

func _get_configuration_warnings() -> PackedStringArray:
	var messages : PackedStringArray = PackedStringArray()
	if health_component == null:
		messages.append("health_component not set for FloatingTextComponent")
	if floatingText == null:
		messages.append("floatingText scene not provided for FloatingTextComponent")  
	return messages

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	if health_component != null:
		health_component.connect("damaged", Callable(self, "on_damage"))
	else :
		print("health_component is null for HitBoxComponent")
	if floatingText == null:
		floatingText = TEXT_SCENE

#TODO - need to pass the spell details, so we can get the type(ice/fire)	
func on_damage(amount : float) -> void:
	print("Hey spawn the floating text for " + str(amount) + " damage")
	spawn(amount)

func spawn(amount: float) -> void:
	var floater : Node2D = floatingText.instantiate()
	var label : Label = floater.get_node("Label");
	label.text = str(amount)
	floater.position = global_position
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(floater, "position", global_position + _get_direction(), 0.75)
	get_tree().current_scene.add_child(floater)

func _get_direction() -> Vector2:
	return Vector2(randf_range(-1,1), -randf()) * 16
