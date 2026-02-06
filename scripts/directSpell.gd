extends Node2D
class_name DirectSpell
@export var speed := 1000

var travelled_distance := 0.0
const MAX_RANGE := 1000
var Target : CharacterBody2D

func _ready() -> void:
	randomize()
	
func set_Target(target : CharacterBody2D) -> void:
	if is_instance_valid(target):
		Target = target
	else:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if Target == null :
		queue_free()
		return
		
	var direction := (Target.global_position - self.global_position).normalized()
	#var direction := (get_global_mouse_position() - self.global_position).normalized()
	position += direction * speed * delta
	travelled_distance += speed * delta
	
	if (travelled_distance > MAX_RANGE):
		queue_free()
	
func _on_body_entered(body : Node2D) -> void:
	#print("DirectSpell hit something " + body.name)
	queue_free()
	if body.has_method("TakeDamage"):
		# pragma warning disable GDSCRIPT_METHOD_NOT_FOUND
		body.TakeDamage(randf_range(1,10))
		 # pragma warning disable GDSCRIPT_METHOD_NOT_FOUND
